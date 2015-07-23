package com.djlsa {
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import com.laiyonghao.Hash;

	/**
	 * @author David Salsinha
	 * 
	 * This class tries to solve the problem of lack of Enumerations in Actionscript 3 by emulating some of Java's Enum features.
	 * To define an Enumeration class, you should just extend this class and declare the Enumeration names as visible static vars
	 * of the same type as the name of the class you're creating. You must call Enum.init(class, ... fields) inside a static
	 * constructor block and initialize each of the static vars with Enum.initValue(class, ... values) if you specified additional
	 * fields for the Enumeration values.
	 * 
	 * @example Example 1:
	 *
	 * public class Example1 extends Enum
	 * {
	 * 		{ Enum.init(Example1); }
	 * 		public static var
	 * 			ONE: Example1,
	 * 			TWO: Example1
	 * 		;
	 * }
	 *
	 * @example Example 2:
	 *
	 * public class Example2 extends Enum
	 * {
	 * 		{ Enum.init(Example2, "number"); }
	 * 		public static var
	 * 			TEN: Enum.initValue(Example2, 10),
	 * 			TWENTY: Enum.initValue(Example2, 20)
	 * 		;
	 * 		public function get number(): Number
	 * 		{
	 * 			return this.values.number;
	 * 		}
	 * }
	 */
	public class Enum
	{
		private var
			/* stores the name of the enumeration value */
			_enumName: String,
			/* stores the additional field values set by Enum.initValue()
			 * this is needed because static variable initialization occurs before the static constructor runs */
			_values: Array = []
		;

		protected var values: Object = {}; // object with additional field values

		private static const
			/* Enum package + class name */
			ENUM_FULLY_QUALIFIED_CLASS_NAME: String = getQualifiedClassName(Enum),
			/* Enum class name */
			ENUM_CLASS_NAME: String = getClassName(ENUM_FULLY_QUALIFIED_CLASS_NAME),
			
			ENUM_INSTANCES: Dictionary = new Dictionary(),
			/* dictionary to get by type and name with Enum.valueOf() ... ENUM_NAMES[type][name] = object */
			ENUM_NAMES: Dictionary = new Dictionary(),
			/* dictionary with additional field names ... ENUM_FIELDS[type] = array w/ field names */
			ENUM_FIELDS: Dictionary = new Dictionary(),
			/* dictionary to get by additional field values with Enum.fromValue() ... ENUM_VALUES[type][hash of field values] = object */
			ENUM_VALUES: Dictionary = new Dictionary()
		;

		private static var
			/* prevent new instances */
			lockConstructor: Boolean = true,
			/* prevent calls to init() and initValue() outside Enum declaration */
			lockInitializer: Dictionary = new Dictionary();
		;

		/*
		 * Auxiliary function to retrieve just the class name from a fully qualified class name string
		 * 
		 * @param fullyQualifiedClassName String containing the fully qualified class name (in the form of package::className)
		 */
		private static function getClassName(fullyQualifiedClassName: String): String
		{
			/* retrieve separator position */
			var separatorIndex: Number = fullyQualifiedClassName.indexOf("::");
			/* return full string if there's no separator or substring from 2 positions ahead to skip it */
			return fullyQualifiedClassName.substring(
				separatorIndex < 0 ?
					0 : separatorIndex + 2
			);
		}

		/**
		 * Constructor, cannot be called from outside this class
		 * @see #fromValue() to create standalone instances
		 */
		public function Enum()
		{
			/* if it's locked, raise an error */
			if(lockConstructor)
				throw new Error("Instances of " + ENUM_CLASS_NAME + " are not allowed");
		}

		/** 
		* Validates a subclass and initializes its public static var members as Enum values
		* 
		* @param classReference Class reference object
		* @param ... fields List of field names
		* 
		*/ 
		protected static function init(classReference: Class, ... values): void
		{
			/* get the class reference's name */
			var
				fullyQualifiedClassName: String = getQualifiedClassName(classReference),
				className: String = getClassName(fullyQualifiedClassName)
			;

			/* check if init() was already called */
			if (classReference in lockInitializer)
				throw new Error(ENUM_CLASS_NAME + ".init() was already called for " + className);

			/* store additional field names for the class */
			ENUM_FIELDS[classReference] = values;

			/* get details about the class */
			var type: XML = describeType(classReference);

			/* iterate over superclass names */
			for each(var superClass: String in type.factory.extendsClass.@type)
			{
				/* check for correct name (i.e.: com.miniclip.davidsalsinha.Enum) */
				if (superClass == ENUM_FULLY_QUALIFIED_CLASS_NAME)
				{
					/* check for constructors or constants, which are not allowed */
					if (type.factory.constructor != undefined || type.factory.constant != undefined)
						throw new Error(className + " and other " + ENUM_CLASS_NAME + " subclasses should not have a constructor or constants");

					/* add class reference to the dictionaries of instances, names and values */
					ENUM_INSTANCES[classReference] = [];
					ENUM_NAMES[classReference] = new Dictionary();
					ENUM_VALUES[classReference] = new Dictionary();

					/* iterate over static vars */
					for each (var variable: XML in type.variable)
					{
						/* check for correct type, should be the same as the class */
						if ( variable.@type != fullyQualifiedClassName )
							throw new Error(ENUM_CLASS_NAME + " value " + className + "." + variable.@name + " should be of type " + className);

						/* an instance to be stored in this var */
						var instance: Enum;

						/* check if the var was not initialized when declared */
						if (classReference[variable.@name] == null)
						{
							/* if Enum.init() specifies additional fields then the vars must be initialized with Enum.initValue() */
							if (values.length > 0)
								throw new Error(ENUM_CLASS_NAME + " value " + className + "." + variable.@name + " should be initialized with " + ENUM_CLASS_NAME + ".initValue(" + className + ", ... values)");

							/* unlock constructor, create new instance and lock again */
							lockConstructor = false;
							instance = new classReference();
							lockConstructor = true;

							/* store new instance in the var */
							classReference[variable.@name] = instance;
						}
						/* if the var was initialized inline with declaration */
						else
						{
							/* retrieve the instance */
							instance = classReference[variable.@name];
							/* check if no values were passed or if the number of value passed is different than the number of fields declared in Enum.init() */
							if (instance._values == null || values.length != instance._values.length)
								throw new Error(ENUM_CLASS_NAME + " value " + className + "." + variable.@name + " should be initialized with the correct number of arguments");
						}

						/* store the name to be displayed on toString() */
						instance._enumName = variable.@name;

						ENUM_INSTANCES[classReference].push(instance);
						/* add to dictionary so that it can be looked up with Enum.valueOf() */
						ENUM_NAMES[classReference][instance._enumName] = instance;

						/* check if there were specified additional fields */
						if (values.length > 0)
						{
							/* calculate the hashcode of the values */
							var valuesHashCode: Number = Hash.JSHash(JSON.stringify(instance._values));
							/* check if there's already an instance with the same values */
							if (values.length > 0 && valuesHashCode in ENUM_VALUES[classReference])
								throw new Error(className + "." + instance._enumName + " can't have the same value as " + className + "." + ENUM_VALUES[classReference][valuesHashCode]);
							/* store the instance so that it can be looked up with Enum.fromValue() */
							ENUM_VALUES[classReference][valuesHashCode] = instance;

							/* populate the instance.values object with the fields as keys and instance._values as values */
							instance.populateValues(classReference);
						}
					}
					ENUM_INSTANCES[classReference] = ENUM_INSTANCES[classReference].sortOn("ordinal");
					/* prevent further calls to Enum.init() and Enum.initValue() for this class */
					lockInitializer[classReference] = true;
					return;
				}
			}
			/* can only reach here if the class doesn't extend Enum */
			throw new Error(ENUM_CLASS_NAME + ".init() should only be used on subclasses of " + ENUM_CLASS_NAME);
		}

		/**
		 * Populates values from instance._values and populates the instance.values object using the class' aditional fields as keys
		 * 
		 * @example Example:
		 * 
		 * instance._values => [1,2]
		 * ENUM_FIELDS[classReference] => ["first","second"]
		 * 
		 * @example Result:
		 *
		 * instance.values = { first: 1, second: 2 }
		 */
		private function populateValues(classReference: Class): void
		{
			/* starting array index */
			var i: Number = 0;
			/* iterate over declared fields */
			for each(var field: String in ENUM_FIELDS[classReference])
				this.values[field] = this._values[i++];
			/* set this._values as null, as this.values now has them with the fields as keys */
				this._values = null;
		}

		protected static function initValue(classReference: Class, ... values): Enum
		{
			/* check if this class has already been initialized */
			if (classReference in lockInitializer)
				throw new Error(ENUM_CLASS_NAME + ".initValue() can only be called inside the " + ENUM_CLASS_NAME + " class declaration");
			/* unlock constructor, create new instance, store values and lock again */
			lockConstructor = false;
			var newInstance: Enum = new classReference();
			newInstance._values = values;
			lockConstructor = true;
			/* return newly created instance */
			return newInstance;
		}

		/*
		 * Since Enum.values() does not always return its members in the order they were declared, this
		 * getter method returns the "ordinal" value, which allows Enum.values(Planet).sortOn("ordinal") to
		 * return an array with Planet's members properly sorted
		 */
		public function get ordinal(): Number
		{
			if(values.hasOwnProperty("ordinal"))
				return values.ordinal;
			return 0;
		}

		public static function values(classReference: Class): Array
		{
			/* check if the class has an entry in the instances dictionary */
			if (classReference in ENUM_INSTANCES)
				return ENUM_INSTANCES[classReference];
			/* if there's no entry for this class then it's not an Enum */
			return null;
		}

		public static function valueOf(classReference: Class, enumName: String): Enum
		{
			if (classReference in ENUM_NAMES)
			{
				if (enumName in ENUM_NAMES[classReference])
					return ENUM_NAMES[classReference][enumName];
			}
			return null;
		}

		public static function fromValue(classReference: Class, ... values): Enum
		{
			if (!classReference in ENUM_FIELDS)
				throw new Error(ENUM_CLASS_NAME + ".fromValue() can't be called inside the class declaration");

			if (values.length == 0)
				throw new Error(ENUM_CLASS_NAME + ".fromValue() should be used to get instances with field values");

			var valuesHashCode: Number = Hash.JSHash(JSON.stringify(values));
			if (valuesHashCode in ENUM_VALUES[classReference])
				return ENUM_VALUES[classReference][valuesHashCode];
			lockConstructor = false;
			var newInstance: Enum = new classReference();
			newInstance._values = values;
			newInstance.populateValues(classReference);
			lockConstructor = true;
			return newInstance;
		}

		public function toString(): String
		{
			if(_enumName)
				return _enumName;
			return "[object " + getClassName(getQualifiedClassName(this)) + "]";
		}
	}
}