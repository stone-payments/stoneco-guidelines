![alt text](../../../../static/horizontal-beeva-logo.png "BEEVA")
# Front-end Development Best Practices

## Guía de estilos para Javascript (ES5 y ES6)

### Tabla de Contenido

  1. [Tipos](#types)
  1. [Referencias](#referencias)
  1. [Objetos](#objects)
  1. [Arrays](#arrays)
  1. [Desestructurado (ES6)](#destructuring)
  1. [Strings](#strings)
  1. [Funciones](#functions)
  1. [Operador Arrow (ES6)](#arrows)
  1. [Constructores (ES6)](#constructores)
  1. [Módulos (ES6)](#modulos)
  1. [Iteradores y generadores (ES6)](#iyg)
  1. [Propiedades](#properties)
  1. [Variables](#variables)
  1. [Hoisting](#hoisting)
  1. [Expresiones de comparación e igualdad](#conditionals)
  1. [Bloques](#blocks)
  1. [Comentarios](#comments)
  1. [Espacios en blanco](#whitespace)
  1. [Comas](#commas)
  1. [Puntos y Comas](#semicolons)
  1. [Casting de Tipos & Coerción](#type-coercion)
  1. [Convenciones de nomenclatura](#naming-conventions)
  1. [Funciones de Acceso](#accessors)
  1. [Eventos](#events)
  1. [jQuery](#jquery)
  1. [Compatibilidad con ES5](#es5)
  1. [Pruebas](#testing)
  1. [Desempeño](#performance)
  1. [Recursos](#resources)

## <a name='types'>Tipos</a>

  - **Primitivos**: Cuando accesas a un tipo primitivo, manejas directamente su valor

    + `string`
    + `number`
    + `boolean`
    + `null`
    + `undefined`

    ```javascript
    var foo = 1;
    let bar = foo;

    bar = 9;

    console.log(foo, bar); // => 1, 9
    ```
  - **Complejo**: Cuando accedes a un tipo complejo, manejas la referencia en memoria.

    + `object`
    + `array`
    + `function`

    ```javascript
    const foo = [1, 2];
    const bar = foo;

    bar[0] = 9;

    console.log(foo[0], bar[0]); // => 9, 9
    ```

**[⬆ Índice](#TOC)**
    
## Referencias

  - Usa `const` para todas las referencias. Evita usar `var`.

  > ¿Por qué? Aseguramos que no se puede reasignar la referencia (mutar), lo que incrementa el número de bugs y dificulta la comprensión del código.

    ```javascript
    // bad
    var a = 1;
    var b = 2;

    // good
    const a = 1;
    const b = 2;
    ```

  - Si las referencias han de mutar, usa `let` en lugar de `var`.

  > ¿Por qué? `let` funcionará sólo en el bloque, mientras que `var` lo hará en toda la función..

    ```javascript
    // mal
    var count = 1;
    if (true) {
      count += 1;
    }

    // bien
    let count = 1;
    if (true) {
      count += 1;
    }
    ```

  - Tanto `let` como `const` son block-scoped.

    ```javascript
    // const y let sólo existen en el bloque en el que han sido definidas
    {
      let a = 1;
      const b = 1;
    }
    console.log(a); // ReferenceError
    console.log(b); // ReferenceError
    ```

**[⬆ Índice](#TOC)**

## <a name='objects'>Objetos</a>

  - Usa la sintaxis literal para la creación de un objeto.

    ```javascript
    // mal
    var item = new Object();

    // bien
    var item = {};
    ```

  - No uses [palabras reservadas](http://es5.github.io/#x7.6.1) para nombres de propiedades. No funciona en IE8. [Más información](https://github.com/airbnb/javascript/issues/61) Sí funcionará en NodeJS.

    ```javascript
    // mal
    var superman = {
      default: { clark: 'kent' },
      private: true
    };

    // bien
    var superman = {
      defaults: { clark: 'kent' },
      hidden: true
    };
    ```

  - Usa sinónimos legibles en lugar de palabras reservadas.

    ```javascript
    // mal
    var superman = {
      class: 'alien'
    };

    // mal
    var superman = {
      klass: 'alien'
    };

    // bien
    var superman = {
      type: 'alien'
    };
    ```
    
  - Cuando un objeto tenga atributos dinámicos, usa métodos para asignar los nombres (ES6).

  > ¿Por qué? Definirás todos las propiedades en un único método.

    ```javascript

    function getKey(k) {
      return `a key named ${k}`;
    }

    // mal
    const obj = {
      id: 5,
      name: 'San Francisco',
    };
    obj[getKey('enabled')] = true;

    // bien
    const obj = {
      id: 5,
      name: 'San Francisco',
      [getKey('enabled')]: true,
    };
    ```

  - Utiliza los métodos cortos (ES6)

    ```javascript
    // mal
    const atom = {
      value: 1,

      addValue: function (value) {
        return atom.value + value;
      },
    };

    // bien
    const atom = {
      value: 1,

      addValue(value) {
        return atom.value + value;
      },
    };
    ```

  - Utiliza los setters de objeto cortos (ES6)

  > Why? It is shorter to write and descriptive.

    ```javascript
    const lukeSkywalker = 'Luke Skywalker';

    // bad
    const obj = {
      lukeSkywalker: lukeSkywalker,
    };

    // good
    const obj = {
      lukeSkywalker,
    };
    ```


**[⬆ Índice](#TOC)**

## <a name='arrays'>Arrays</a>

  - Usa la sintaxis literal para la creación de arreglos

    ```javascript
    // mal
    var items = new Array();

    // bien
    var items = [];
    ```

  - Usa Array#push, en vez de asignación directa, para agregar elementos a un arreglo.

    ```javascript
    var someStack = [];


    // mal
    someStack[someStack.length] = 'abracadabra';

    // bien
    someStack.push('abracadabra');
    ```

  - Cuando necesites copiar un arreglo usa Array#slice.

    ```javascript
    var len = items.length;
    var itemsCopy = [];
    var i;

    // mal
    for (i = 0; i < len; i++) {
      itemsCopy[i] = items[i];
    }

    // bien
    itemsCopy = items.slice();
    ```
    
  - Usa spreads `...` para copiar un array (ES6)
  
    ```javascript
    // MAL
    const len = items.length;
    const itemsCopy = [];
    let i;

    for (i = 0; i < len; i++) {
      itemsCopy[i] = items[i];
    }

    // bien
    const itemsCopy = [...items];
    ```
    
  - Para convertir un objeto ["array-like" (similar a un arreglo)](https://www.inkling.com/read/javascript-definitive-guide-david-flanagan-6th/chapter-7/array-like-objects) a un arreglo, usa Array#slice.
  

    ```javascript
    function trigger() {
      var args = Array.prototype.slice.call(arguments);
      ...
    }
    ```
  - Para convertir un objeto ["array-like" (similar a un arreglo)](https://www.inkling.com/read/javascript-definitive-guide-david-flanagan-6th/chapter-7/array-like-objects) a un arreglo, usa Array#from (ES6)

    ```javascript
    const foo = document.querySelectorAll('.foo');
    const nodes = Array.from(foo);
    ```

**[⬆ Índice](#TOC)**

## <a name="destructuring">Desestructurado (ES6)</a>

  - Usa la desestructuración de objetos cuando se accede a múltiples propiedades de un objeto.

  > ¿Por qué? Evitas crear referencias temporales a estos objetos.

    ```javascript
    // mal
    function getFullName(user) {
      const firstName = user.firstName;
      const lastName = user.lastName;

      return `${firstName} ${lastName}`;
    }

    // bien
    function getFullName(obj) {
      const { firstName, lastName } = obj;
      return `${firstName} ${lastName}`;
    }

    // mejor
    function getFullName({ firstName, lastName }) {
      return `${firstName} ${lastName}`;
    }
    ```

  - Desesturcturado de Arrays

    ```javascript
    const arr = [1, 2, 3, 4];

    // mal
    const first = arr[0];
    const second = arr[1];

    // bien
    const [first, second] = arr;
    ```

  - Usa la desestructuración de objetos para returns múltiples.

  > ¿Por qué? Puedes añadir nuevas propiedades o modificar el orden a lo largo del script.

    ```javascript
    // mal
    function processInput(input) {
      // then a miracle occurs
      return [left, right, top, bottom];
    }

    // hay que estar pendiente del orden...
    const [left, __, top] = processInput(input);

    // bien
    function processInput(input) {
      // then a miracle occurs
      return { left, right, top, bottom };
    }

    // sólo elegimos los datos que necesitamos
    const { left, right } = processInput(input);
    ```
**[⬆ Índice](#TOC)**

## <a name='strings'>Strings</a>

  - Usa comillas simples `''` para las cadenas de texto

    ```javascript
    // mal
    const name = "Bob Parr";

    // bien
    const name = 'Bob Parr';

    ```

  - Las cadenas de texto con una longitud mayor a 100 caracteres deben ser escritas en múltiples líneas usando concatenación.
  
    ```javascript
    // mal
    const errorMessage = 'This is a super long error that was thrown because of Batman. When you stop to think about how Batman had anything to do with this, you would get nowhere fast.';

    // bien
    const errorMessage = 'This is a super long error that was thrown because\
    of Batman. When you stop to think about how Batman had anything to do \
    with this, you would get nowhere fast.';


    // bien
    const errorMessage = 'This is a super long error that was thrown because' +
      'of Batman. When you stop to think about how Batman had anything to do ' +
      'with this, you would get nowhere fast.';
    ```

  - Usa templating en lugar de concatenaciones (ES6)

  > ¿Por qué? Hace más legible y conciso el código.

    ```javascript
    // mal
    function sayHi(name) {
      return 'How are you, ' + name + '?';
    }

    // mal
    function sayHi(name) {
      return ['How are you, ', name, '?'].join();
    }

    // bien
    function sayHi(name) {
      return `How are you, ${name}?`;
    }
    ```
  - NUNCA uses eval() sobre un string. Es la mejor puerta de entrada a las vulnerabilidades en JS

**[⬆ Índice](#TOC)**

## <a name="functions">Funciones</a>

  - Declara funciones en lugar de asignarlas a variables

  > ¿Por qué? Al ser nominales, las declaraciones de funciones aparecen en la pila de llamadas y facilitan su identificación en el "debugging" Además, las declaraciones son "subidas" al principio (hoisting) y estarán disponibles en todo el scope. De esta forma, además, siempre podremos utilizar el operador Arrow (ES6)

    ```javascript
    // mal
    const foo = function () {
    };

    // bien
    function foo() {
    }
    ```

  - Funciones autoinvocadas

    ```javascript
    // ES6
    (() => {
      console.log('Welcome to the Internet. Please follow me.');
    })();
    
    // ES5
    (function() {
      console.log('Welcome to the Internet. Please follow me.');
    })();
    ```

  - No declares nunca una función en un bucle, un if, ... 

    ```javascript
    // mal
    if (currentUser) {
      function test() {
        console.log('Nope.');
      }
    }

    // bien
    let test;
    if (currentUser) {
      test = () => {
        console.log('Yup.');
      };
    }
    ```

  - Nunca utilices un parámetro llamado `arguments` ya que Javascript lo declara de forma automática

    ```javascript
    // mal
    function nope(name, options, arguments) {
      // ...stuff...
    }

    // bien
    function yup(name, options, args) {
      // ...stuff...
    }
    ```

  - Nunca uses `arguments`, usa `...` en su lugar (ES6)

    ```javascript
    // mal
    function concatenateAll() {
      const args = Array.prototype.slice.call(arguments);
      return args.join('');
    }

    // bien
    function concatenateAll(...args) {
      return args.join('');
    }
    ```

  - Usa parámetros por defecto (ES6)

    ```javascript
    // FATAL
    function handleThings(opts) {
      // No! We shouldn't mutate function arguments.
      // Double bad: if opts is falsy it'll be set to an object which may
      // be what you want but it can introduce subtle bugs.
      opts = opts || {};
      // ...
    }

    // mal
    function handleThings(opts) {
      if (opts === void 0) {
        opts = {};
      }
      // ...
    }

    // bien
    function handleThings(opts = {}) {
      // ...
    }
    ```

  - Evita modificadores en los parámetros por defecto (ES6)

  > ¿Por qué? Confunden....

  ```javascript
  var b = 1;
  // mal
  function count(a = b++) {
    console.log(a);
  }
  count();  // 1
  count();  // 2
  count(3); // 3
  count();  // 3
  ```

  - Pon siempre los parámetros por defecto al final (ES6)

    ```javascript
    // mal
    function handleThings(opts = {}, name) {
      // ...
    }

    // bien
    function handleThings(name, opts = {}) {
      // ...
    }
    ```

- Nunca uses la funcion "Function" para nombrar a una función

  > ¿Por qué? Hace cosas similares al eval...permitiendo vulnerabilidades.

  ```javascript
  // mal
  var add = new Function('a', 'b', 'return a + b');

  // igual de mal
  var subtract = Function('a', 'b', 'return a - b');
  ```

**[⬆ Índice](#TOC)**

## <a name="arrows">Operador Arrow (ES6)</a>

  - Usa siempre el operador Arrow para pasar por parámetro funciones anónimas.

  > ¿Por qué? Evitamos problemas de contexto `this` y es mucho más legible.

  > ¿Por qué no? Si la función es muy compleja, deberás declararla a parte.

    ```javascript
    // mal
    [1, 2, 3].map(function (x) {
      const y = x + 1;
      return x * y;
    });

    // bien
    [1, 2, 3].map((x) => {
      const y = x + 1;
      return x * y;
    });
    ```

  - Si el cuerpo de la función es una expresión sencilla, no utilices llaves ni return (aunque puedes hacerlo)

  > ¿Por qué? Más legible y corto.

  > No lo hagas si vas a devolver un objeto.

    ```javascript
    // bien
    [1, 2, 3].map(number => `A string containing the ${number}.`);

    // mal
    [1, 2, 3].map(number => {
      const nextNumber = number + 1;
      `A string containing the ${nextNumber}.`;
    });

    // bien
    [1, 2, 3].map(number => {
      const nextNumber = number + 1;
      return `A string containing the ${nextNumber}.`;
    });
    ```

  - Si la expresión require de varias líneas, utiliza siempre paréntesis para mejorar la legibilidad.

  > ¿Por qué? Clarifica el inicio y el final

    ```js
    // mal
    [1, 2, 3].map(number => 'As time went by, the string containing the ' +
      `${number} became much longer. So we needed to break it over multiple ` +
      'lines.'
    );

    // bien
    [1, 2, 3].map(number => (
      `As time went by, the string containing the ${number} became much ` +
      'longer. So we needed to break it over multiple lines.'
    ));
    ```


  - Si tu función tiene sólo un argumento, omite los paréntesis.

    ```js
    // bien
    [1, 2, 3].map(x => x * x);

    // bien
    [1, 2, 3].reduce((y, x) => x + y);
    ```

**[⬆ Índice](#TOC)**


## <a name="constructores">Constructores (ES6)</a>

  - Usa siempre `class`. Evita modificar directamente el `prototype`.

  > ¿Por qué? `class` es más conciso y fácil de entender.

    ```javascript
    // mal
    function Queue(contents = []) {
      this._queue = [...contents];
    }
    Queue.prototype.pop = function() {
      const value = this._queue[0];
      this._queue.splice(0, 1);
      return value;
    }


    // bien
    class Queue {
      constructor(contents = []) {
        this._queue = [...contents];
      }
      pop() {
        const value = this._queue[0];
        this._queue.splice(0, 1);
        return value;
      }
    }
    ```

  - Usa `extends` para herencia

    ```javascript
    // mal
    const inherits = require('inherits');
    function PeekableQueue(contents) {
      Queue.apply(this, contents);
    }
    inherits(PeekableQueue, Queue);
    PeekableQueue.prototype.peek = function() {
      return this._queue[0];
    }

    // bien
    class PeekableQueue extends Queue {
      peek() {
        return this._queue[0];
      }
    }
    ```

  - Los métodos pueden devolver `this` para ayudar a concatenar funciones.

    ```javascript
    // mal
    Jedi.prototype.jump = function() {
      this.jumping = true;
      return true;
    };

    Jedi.prototype.setHeight = function(height) {
      this.height = height;
    };

    const luke = new Jedi();
    luke.jump(); // => true
    luke.setHeight(20); // => undefined

    // bien
    class Jedi {
      jump() {
        this.jumping = true;
        return this;
      }

      setHeight(height) {
        this.height = height;
        return this;
      }
    }

    const luke = new Jedi();

    luke.jump()
      .setHeight(20);
    ```


  - Está bien crear un método personalizado toString. Asegúrate de que no tiene efectos no deseados.

    ```javascript
    class Jedi {
      constructor(options = {}) {
        this.name = options.name || 'no name';
      }

      getName() {
        return this.name;
      }

      toString() {
        return `Jedi - ${this.getName()}`;
      }
    }
    ```

**[⬆ Índice](#TOC)**


## <a name="modulos">Módulos (ES6)</a>

  - Usa siempre (`import`/`export`) en lugar de otros métodos no estandarizados.

    ```javascript
    // mal
    const AirbnbStyleGuide = require('./AirbnbStyleGuide');
    module.exports = AirbnbStyleGuide.es6;

    // bien
    import AirbnbStyleGuide from './AirbnbStyleGuide';
    export default AirbnbStyleGuide.es6;

    // mejor
    import { es6 } from './AirbnbStyleGuide';
    export default es6;
    ```

  - No importes todo utilizando el operador *. Importa sólo lo que necesites.

    ```javascript
    // mal
    import * as AirbnbStyleGuide from './AirbnbStyleGuide';

    // bien
    import AirbnbStyleGuide from './AirbnbStyleGuide';
    ```

  - No exportes directamente sobre un import.

    ```javascript
    // mal
    // filename es6.js
    export { es6 as default } from './airbnbStyleGuide';

    // bien
    // filename es6.js
    import { es6 } from './AirbnbStyleGuide';
    export default es6;
    ```

**[⬆ Índice](#TOC)**

## <a name="iyg">Iteradores y generadores (ES6)</a>

  - No utilices los iteradores por defecto. Utiliza `map()` y `reduce()` en lugar de blucles `for-of`.

    ```javascript
    const numbers = [1, 2, 3, 4, 5];

    // mal
    let sum = 0;
    for (let num of numbers) {
      sum += num;
    }

    sum === 15;

    // bien
    let sum = 0;
    numbers.forEach((num) => sum += num);
    sum === 15;

    // mejor
    const sum = numbers.reduce((total, num) => total + num, 0);
    sum === 15;
    ```

  - De momento, no uses generadores.

  > ¿Por qué? Actualmente, no transpilan bien en ES5.

**[⬆ Índice](#TOC)**


## <a name='properties'>Propiedades</a>

  - Usa la notación de punto `.` cuando accedas a las propiedades.

    ```javascript
    var luke = {
      jedi: true,
      age: 28
    };

    // mal
    var isJedi = luke['jedi'];

    // bien
    var isJedi = luke.jedi;
    ```

  - Usa la notación subscript `[]` cuando accedas a las propiedades con una variable.

    ```javascript
    var luke = {
      jedi: true,
      age: 28
    };

    function getProp(prop) {
      return luke[prop];
    }

    var isJedi = getProp('jedi');
    ```

**[⬆ Índice](#TOC)**


## <a name='variables'>Variables</a>

  - Siempre usa `const` para declarar variables. No hacerlo generará variables globales. Debemos evitar contaminar el espacio global (global namespace).

    ```javascript
    // mal
    superPower = new SuperPower();

    // bien
    const superPower = new SuperPower();
    ```

  - Usa una declaración `const` por variable.

    ```javascript
    // mal
    var items = getItems(),
        goSportsTeam = true,
        dragonball = 'z';

    // mal
    // (compara con lo de encima y trata de encontrar el error)
    var items = getItems(),
        goSportsTeam = true;
        dragonball = 'z';

    // bien
    const items = getItems();
    const goSportsTeam = true;
    const dragonball = 'z';
    ```

  - Agrupa todas tus `const`s y después agrupa los `let`s.

    ```javascript
    // bad
    let i, len, dragonball,
        items = getItems(),
        goSportsTeam = true;

    // bad
    let i;
    const items = getItems();
    let dragonball;
    const goSportsTeam = true;
    let len;

    // good
    const goSportsTeam = true;
    const items = getItems();
    let dragonball;
    let i;
    let length;
    ```



 - Asigna las variables donde las necesites, pero en un sitio razonable.

  > ¿Por qué? `let` y `const` son block scoped y no function scoped.

    ```javascript
    // bien
    function() {
      test();
      console.log('doing stuff..');

      //..other stuff..

      const name = getName();

      if (name === 'test') {
        return false;
      }

      return name;
    }

    // mall - unnecessary function call
    function(hasName) {
      const name = getName();

      if (!hasName) {
        return false;
      }

      this.setFirstName(name);

      return true;
    }

    // bien
    function(hasName) {
      if (!hasName) {
        return false;
      }

      const name = getName();
      this.setFirstName(name);

      return true;
    }
    ```

**[⬆ Índice](#TOC)**


## <a name='hoisting'>Hoisting</a>

  - Las declaraciones de variables son movidas a la parte superior de su ámbito (scope), sin embargo su asignación no. `const` y `let` se declaran utilizando un nuevo concepto [Temporal Dead Zones (TDZ)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let#Temporal_dead_zone_and_errors_with_let). Has de saber que [typeof deja de ser seguro](http://es-discourse.com/t/why-typeof-is-no-longer-safe/15).

    ```javascript
    // sabemos que esto no funcionara (asumiendo
    // que no hay una variable global notDefined)
    function example() {
      console.log(notDefined); // => lanza un ReferenceError
    }

    // crear una declaracion de variable luego
    // que referencies a la variable funcionara
    // por el hoisting. Nota: A la asignacion
    // del valor `true` no se le aplico hoisting.
    function example() {
      console.log(declaredButNotAssigned); // => undefined
      var declaredButNotAssigned = true;
    }
    

    // using const and let
    function example() {
      console.log(declaredButNotAssigned); // => throws a ReferenceError
      console.log(typeof declaredButNotAssigned); // => throws a ReferenceError
      const declaredButNotAssigned = true;
    }

    // El interprete hizo hoisting.
    // Eso significa que nuestro ejemplo
    // podria ser reescrito como:
    function example() {
      var declaredButNotAssigned;
      console.log(declaredButNotAssigned); // => undefined
      declaredButNotAssigned = true;
    }
    ```

  - Expresiones de función anónimas hacen hoisting de su nombre de variable, pero no de la asignación de la función.

    ```javascript
    function example() {
      console.log(anonymous); // => undefined

      anonymous(); // => TypeError anonymous is not a function

      var anonymous = function() {
        console.log('anonymous function expression');
      };
    }
    ```

  - Expresiones de función nominales hacen hoisting de su nombre de variable, pero no del nombre de la función ni del contenido de la función.

    ```javascript
    function example() {
      console.log(named); // => undefined

      named(); // => TypeError named is not a function

      superPower(); // => ReferenceError superPower is not defined

      var named = function superPower() {
        console.log('Flying');
      };
    }

    // lo mismo es cierto cuando el nombre
    // de la funcion es igual al nombre de
    // la variable.
    function example() {
      console.log(named); // => undefined

      named(); // => TypeError named is not a function

      var named = function named() {
        console.log('named');
      }
    }
    ```

  - Las declaraciones de función hacen hoist de su nombre y del contenido de la función.

    ```javascript
    function example() {
      superPower(); // => Flying

      function superPower() {
        console.log('Flying');
      }
    }
    ```

  - Para más información lee [JavaScript Scoping & Hoisting](http://www.adequatelygood.com/2010/2/JavaScript-Scoping-and-Hoisting) por [Ben Cherry](http://www.adequatelygood.com/)

**[⬆ Índice](#TOC)**



## <a name='conditionals'>Expresiones de comparación e igualdad</a>

  - Usa `===` y `!==` en vez de `==` y `!=` respectivamente.
  - Expresiones condicionales son evaluadas usando coerción con el método `ToBoolean` y siempre obedecen a estas reglas sencillas:

    + **Objects** son evaluados como **true**
    + **Undefined** es evaluado como **false**
    + **Null** es evaluado como **false**
    + **Booleans** son evaluados como **el valor del booleano**
    + **Numbers** son evaluados como **false** si **+0**, **-0**, o **NaN**, de otro modo **true**
    + **Strings** son evaluados como **false** si es una cadena de texto vacía `''`, de otro modo son **true**

    ```javascript
    if ([0]) {
      // true
      // un arreglo es un objeto, los objetos son evaluados como true
    }
    ```

  - Usa atajos.

    ```javascript
    // mal
    if (name !== '') {
      // ...stuff...
    }

    // bien
    if (name) {
      // ...stuff...
    }

    // mal
    if (collection.length > 0) {
      // ...stuff...
    }

    // bien
    if (collection.length) {
      // ...stuff...
    }
    ```

  - Para más información revisa [Truth Equality and JavaScript](http://javascriptweblog.wordpress.com/2011/02/07/truth-equality-and-javascript/#more-2108) por Angus Croll

**[⬆ Índice](#TOC)**


## <a name='blocks'>Bloques</a>

  - Usa llaves con todos los bloques de múltiples líneas.

    ```javascript
    // mal
    if (test)
      return false;

    // bien
    if (test) return false;

    // bien
    if (test) {
      return false;
    }

    // mal
    function() { return false; }

    // bien
    function() {
      return false;
    }
    ```

**[⬆ Índice](#TOC)**


## <a name='comments'>Comentarios</a>

  - Usa `/** ... */` para comentarios de múltiples líneas. Incluye una descripción, especificación de tipos y valores para todos los parámetros y valores de retorno.

    ```javascript
    // mal
    // make() returns a new element
    // based on the passed in tag name
    //
    // @param <String> tag
    // @return <Element> element
    function make(tag) {

      // ...stuff...

      return element;
    }

    // bien
    /**
     * make() returns a new element
     * based on the passed in tag name
     *
     * @param <String> tag
     * @return <Element> element
     */
    function make(tag) {

      // ...stuff...

      return element;
    }
    ```

  - Usa `//` para comentarios de una sola línea. Ubica los comentarios de una sola línea encima del sujeto comentado. Deja una línea en blanco antes del comentario.

    ```javascript
    // mal
    var active = true;  // is current tab

    // bien
    // is current tab
    var active = true;

    // mal
    function getType() {
      console.log('fetching type...');
      // set the default type to 'no type'
      var type = this._type || 'no type';

      return type;
    }

    // bien
    function getType() {
      console.log('fetching type...');

      // set the default type to 'no type'
      var type = this._type || 'no type';

      return type;
    }
    ```

  - Agregando a tus comentarios los prefijos `FIXME` o `TODO`, ayudará a otros desarrolladores a entender rápidamente si estás apuntando a un problema que precisa ser revisado o si estás sugiriendo una solución al problema que debería ser implementado. Estos son diferentes a comentarios regulares en el sentido que requieren alguna acción. Las acciones son `FIXME -- necesito resolver esto` o `TODO -- necesita implementarse`.

  - Usa `// FIXME:` para anotar problemas.

    ```javascript
    function Calculator() {

      // FIXME: shouldn't use a global here
      total = 0;

      return this;
    }
    ```

  - Usa `// TODO:` para anotar soluciones a los problemas.

    ```javascript
    function Calculator() {

      // TODO: total should be configurable by an options param
      this.total = 0;

      return this;
    }
  ```

**[⬆ Índice](#TOC)**


## <a name='whitespace'>Espacios en blanco</a>

  - Usa indentaciones blandas (sin TAB)  establecidas en dos espacios.

    ```javascript
    // mal
    function() {
    ∙∙∙∙var name;
    }

    // mal
    function() {
    ∙var name;
    }

    // bien
    function() {
    ∙∙var name;
    }
    ```
  - Deja un espacio antes de la llave de apertura.

    ```javascript
    // mal
    function test(){
      console.log('test');
    }

    // bien
    function test() {
      console.log('test');
    }

    // mal
    dog.set('attr',{
      age: '1 year',
      breed: 'Bernese Mountain Dog'
    });

    // bien
    dog.set('attr', {
      age: '1 year',
      breed: 'Bernese Mountain Dog'
    });
    ```
  - Deja una línea en blanco al final del archivo.

    ```javascript
    // mal
    (function(global) {
      // ...algo...
    })(this);
    ```

    ```javascript
    // bien
    (function(global) {
      // ...algo...
    })(this);

    ```

  - Usa indentación cuando uses métodos largos con 'chaining'.

    ```javascript
    // mal
    $('#items').find('.selected').highlight().end().find('.open').updateCount();

    // bien
    $('#items')
      .find('.selected')
        .highlight()
        .end()
      .find('.open')
        .updateCount();

    // mal
    var leds = stage.selectAll('.led').data(data).enter().append('svg:svg').class('led', true)
        .attr('width',  (radius + margin) * 2).append('svg:g')
        .attr('transform', 'translate(' + (radius + margin) + ',' + (radius + margin) + ')')
        .call(tron.led);

    // bien
    var leds = stage.selectAll('.led')
        .data(data)
      .enter().append('svg:svg')
        .class('led', true)
        .attr('width',  (radius + margin) * 2)
      .append('svg:g')
        .attr('transform', 'translate(' + (radius + margin) + ',' + (radius + margin) + ')')
        .call(tron.led);
    ```
**[⬆ Índice](#TOC)**


## <a name='commas'>Comas</a>

  - Comas al inicio de línea: **Nop.**

    ```javascript
    // mal
    var story = [
        once
      , upon
      , aTime
    ];

    // bien
    var story = [
      once,
      upon,
      aTime
    ];

    // mal
    var hero = {
        firstName: 'Bob'
      , lastName: 'Parr'
      , heroName: 'Mr. Incredible'
      , superPower: 'strength'
    };

    // bien
    var hero = {
      firstName: 'Bob',
      lastName: 'Parr',
      heroName: 'Mr. Incredible',
      superPower: 'strength'
    };
    ```

  - Coma adicional al final: **Nop.** Esto puede provocar problemas en IE6/7 o IE9 si está en quirksmode. Además, en algunas implementaciones de ES3 se puede aumentar la longitud del arreglo si se tiene una coma adicional al final. Esto fue clarificado en ES5 ([fuente](http://es5.github.io/#D)):

  > La Edición 5 aclara el hecho de que dejar una coma al final de un ArrayInitialiser (inicialización de un arreglo) no aumenta la longitud del arreglo. Esto no es un cambio semántico a la Edición 3 pero algunas implementaciones tal vez malinterpretaron esto.

    ```javascript
    // mal
    var hero = {
      firstName: 'Kevin',
      lastName: 'Flynn',
    };

    var heroes = [
      'Batman',
      'Superman',
    ];

    // bien
    var hero = {
      firstName: 'Kevin',
      lastName: 'Flynn'
    };

    var heroes = [
      'Batman',
      'Superman'
    ];
    ```

**[⬆ Índice](#TOC)**


## <a name='semicolons'>Puntos y Comas</a>

  - **Sip.**

    ```javascript
    // mal
    (function() {
      var name = 'Skywalker'
      return name
    })()

    // bien
    (function() {
      var name = 'Skywalker';
      return name;
    })();

    // bien
    ;(function() {
      var name = 'Skywalker';
      return name;
    })();
    ```

**[⬆ Índice](#TOC)**


## <a name='type-coercion'>Casting de Tipos & Coerción</a>

  - Ejecuta coerción al inicio de una sentencia.
  - Strings:

    ```javascript
    //  => this.reviewScore = 9;

    // mal
    var totalScore = this.reviewScore + '';

    // bien
    var totalScore = '' + this.reviewScore;

    // mal
    var totalScore = '' + this.reviewScore + ' total score';

    // bien
    var totalScore = this.reviewScore + ' total score';
    ```

  - Usa `parseInt` para números y siempre con la base numérica para el casting de tipo.

    ```javascript
    var inputValue = '4';

    // mal
    var val = new Number(inputValue);

    // mal
    var val = +inputValue;

    // mal
    var val = inputValue >> 0;

    // mal
    var val = parseInt(inputValue);

    // bien
    var val = Number(inputValue);

    // bien
    var val = parseInt(inputValue, 10);
    ```

  - Si por alguna razón estás haciendo algo salvaje y `parseInt` es un cuello de botella por lo que necesitaste usar Bitshift por [razones de desempeño](http://jsperf.com/coercion-vs-casting/3), deja un comentario explicando qué y porqué lo estás haciendo.
  - **Nota:** Ten mucho cuidado al hacer operaciones de Bitshift. En Javascript los números son representados como [valores de 64-bit](http://es5.github.io/#x4.3.19), sin embargo las operaciones de Bitshift siempre retornan un entero de 32-bits ([fuente](http://es5.github.io/#x11.7)). Bitshift puede presentarnos un comportamiento inesperado para valores enteros mayores a 32 bits. [Discusión](https://github.com/airbnb/javascript/issues/109)


    ```javascript
    // bien
    /**
     * parseInt was the reason my code was slow.
     * Bitshifting the String to coerce it to a
     * Number made it a lot faster.
     */
    var val = inputValue >> 0;
    ```

  - Booleans:

    ```javascript
    var age = 0;

    // mal
    var hasAge = new Boolean(age);

    // bien
    var hasAge = Boolean(age);

    // bien
    var hasAge = !!age;
    ```

    **[[⬆ regresar a la Tabla de Contenido]](#TOC)**


## <a name='naming-conventions'>Convenciones de nomenclatura</a>

  - Evita nombres de una sola letra. Sé descriptivo con tus nombres.

    ```javascript
    // mal
    function q() {
      // ...algo...
    }

    // bien
    function query() {
      // ...algo...
    }
    ```

  - Usa camelCase cuando nombres tus objetos, funciones e instancias.

    ```javascript
    // bad
    const OBJEcttsssss = {};
    const this_is_my_object = {};
    function c() {}

    // good
    const thisIsMyObject = {};
    function thisIsMyFunction() {}
    ```

  - Usa PascalCase cuando nombres constructores o clases.

    ```javascript
    // mal
    function user(options) {
      this.name = options.name;
    }

    const bad = new user({
      name: 'nope',
    });

    // bien
    class User {
      constructor(options) {
        this.name = options.name;
      }
    }

    const good = new User({
      name: 'yup',
    });
    ```

  - Usa un guión bajo `_` adelante de la variable cuando nombres propiedades privadas.

    ```javascript
    // mal
    this.__firstName__ = 'Panda';
    this.firstName_ = 'Panda';

    // bien
    this._firstName = 'Panda';
    ```

  - No guardes referencias a this. Usa funciones arrow o la función bind

    ```javascript
    // bad
    function foo() {
      const self = this;
      return function() {
        console.log(self);
      };
    }

    // bad
    function foo() {
      const that = this;
      return function() {
        console.log(that);
      };
    }

    // good
    function foo() {
      return () => {
        console.log(this);
      };
    }
    ```

  - Nombra tus funciones. Esto será de ayuda cuando hagas seguimiento de la pila de llamadas (e.g. en caso de errores).

    ```javascript
    // mal
    var log = function(msg) {
      console.log(msg);
    };

    // bien
    var log = function log(msg) {
      console.log(msg);
    };
    ```
    
  - Si tu fichero exporta una única clase, el fichero ha de llamarse exactamente igual que la clase.

    ```javascript
    // file contents
    class CheckBox {
      // ...
    }
    export default CheckBox;

    // in some other file
    // bad
    import CheckBox from './checkBox';

    // bad
    import CheckBox from './check_box';

    // good
    import CheckBox from './CheckBox';
    ```

  - Usa camelCase cuando exportes una función por defecto. El fichero ha de llamarse igual que la función.

    ```javascript
    function makeStyleGuide() {
    }

    export default makeStyleGuide;
    ```

  - Usa PascalCase cuando exportes un singleton / librería u objeto.

    ```javascript
    const AirbnbStyleGuide = {
      es6: {
      }
    };

    export default AirbnbStyleGuide;
    ```
    

**[⬆ Índice](#TOC)**


## <a name='accessors'>Funciones de Acceso</a>

  - Funciones de acceso para las propiedades no son requeridas.
  - Si creas funciones de acceso usa  getVal() y setVal('hello').

    ```javascript
    // mal
    dragon.age();

    // bien
    dragon.getAge();

    // mal
    dragon.age(25);

    // bien
    dragon.setAge(25);
    ```

  - Si la propiedad es un booleano, usa isVal() o hasVal().

    ```javascript
    // mal
    if (!dragon.age()) {
      return false;
    }

    // bien
    if (!dragon.hasAge()) {
      return false;
    }
    ```

  - Está bien crear funciones get() y set(), pero sé consistente.

    ```javascript
    class Jedi {
      constructor(options = {}) {
        const lightsaber = options.lightsaber || 'blue';
        this.set('lightsaber', lightsaber);
      }

      set(key, val) {
        this[key] = val;
      }

      get(key) {
        return this[key];
      }
    }
    ```

**[⬆ Índice](#TOC)**


## <a name='events'>Eventos</a>

  - Cuando envies paquetes de datos a los eventos (ya sea con eventos del DOM o algo propietario como los eventos de Backbone), pasa un mapa en vez de un valor directo. Esto permitirá a un próximo colaborador a agregar más datos al paquete de datos sin que tenga que encontrar o actualizar un handler para cada evento. Por ejemplo, en vez de:

    ```js
    // mal
    $(this).trigger('listingUpdated', listing.id);

    ...

    $(this).on('listingUpdated', function(e, listingId) {
      // hacer algo con listingId
    });
    ```

    mejor...:

    ```js
    // bien
    $(this).trigger('listingUpdated', { listingId : listing.id });

    ...

    $(this).on('listingUpdated', function(e, data) {
      // hacer algo con data.listingId
    });
    ```

**[⬆ Índice](#TOC)**


## <a name='jquery'>jQuery</a>

  - Nombre las variables de objetos jQuery con un prefijo `$`.

    ```javascript
    // bad
    const sidebar = $('.sidebar');

    // good
    const $sidebar = $('.sidebar');

    // good
    const $sidebarBtn = $('.sidebar-btn');
    ```

  - Guarde en variables los lookups de jQuery que se necesiten posteriormente.

    ```javascript
    // bad
    function setSidebar() {
      $('.sidebar').hide();

      // ...stuff...

      $('.sidebar').css({
        'background-color': 'pink'
      });
    }

    // good
    function setSidebar() {
      const $sidebar = $('.sidebar');
      $sidebar.hide();

      // ...stuff...

      $sidebar.css({
        'background-color': 'pink'
      });
    }
    ```

  - Para consultas de elementos DOM usa el modo Cascada `$('.sidebar ul')` o parent > child `$('.sidebar > ul')`. [jsPerf](http://jsperf.com/jquery-find-vs-context-sel/16)
  - Usa `find` solo con consultas guardadas en variables previamente.

    ```javascript
    // mal
    $('ul', '.sidebar').hide();

    // mal
    $('.sidebar').find('ul').hide();

    // bien
    $('.sidebar ul').hide();

    // bien
    $('.sidebar > ul').hide();

    // bien
    $sidebar.find('ul');
    ```

**[⬆ Índice](#TOC)**


## <a name='es5'>Compatibilidad con ECMAScript 5</a>

  - Revisa la [tabla de compatibilidad](http://kangax.github.com/es5-compat-table/) de ES5 de [Kangax](https://twitter.com/kangax/).

**[⬆ Índice](#TOC)**


## <a name='testing'>Testing</a>

  - **Sip**.

    ```javascript
    function() {
      return true;
    }
    ```

    **[[⬆ regresar a la Tabla de Contenido]](#TOC)**


## <a name='performance'>Rendimiento y performance</a>

  - [On Layout & Web Performance](http://kellegous.com/j/2013/01/26/layout-performance/)
  - [String vs Array Concat](http://jsperf.com/string-vs-array-concat/2)
  - [Try/Catch Cost In a Loop](http://jsperf.com/try-catch-in-loop-cost)
  - [Bang Function](http://jsperf.com/bang-function)
  - [jQuery Find vs Context, Selector](http://jsperf.com/jquery-find-vs-context-sel/13)
  - [innerHTML vs textContent for script text](http://jsperf.com/innerhtml-vs-textcontent-for-script-text)
  - [Long String Concatenation](http://jsperf.com/ya-string-concat)
  - Loading...

  **[[⬆ regresar a la Tabla de Contenido]](#TOC)**


## <a name='resources'>Recursos</a>


**Lee esto**

  - [Annotated ECMAScript 5.1](http://es5.github.com/)

**Otras guías de estilo**

  - [Google JavaScript Style Guide](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml) (Guía de Estilo de Javascript de Google)
  - [jQuery Core Style Guidelines](http://docs.jquery.com/JQuery_Core_Style_Guidelines) (Lineamientos de Estilo con el núcleo de jQuery)
  - [Principles of Writing Consistent, Idiomatic JavaScript](https://github.com/rwldrn/idiomatic.js/) (Idiomatic Javascript: Principios de Escritura Consistente)
  - [AirBnB](https://github.com/airbnb/javascript) (la guía en la que nos hemos basado)

**Otros estilos**

  - [Naming this in nested functions](https://gist.github.com/4135065) - Christian Johansen (Nomenclatura en funciones anidadas)
  - [Conditional Callbacks](https://github.com/airbnb/javascript/issues/52) (Callbacks condicionales)
  - [Popular JavaScript Coding Conventions on Github](http://sideeffect.kr/popularconvention/#javascript) (Convenciones Populares de Programación con Javascript en Github)

**Lecturas más profundas**

  - [Understanding JavaScript Closures](http://javascriptweblog.wordpress.com/2010/10/25/understanding-javascript-closures/) - Angus Croll (Entendiendo los Closures de JavaScript)
  - [Basic JavaScript for the impatient programmer](http://www.2ality.com/2013/06/basic-javascript.html) - Dr. Axel Rauschmayer (JavaScript Básico para el programador impaciente)

**Libros**

  - [JavaScript: The Good Parts](http://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742) - Douglas Crockford (JavaScript: Las Buenas Partes)
  - [JavaScript Patterns](http://www.amazon.com/JavaScript-Patterns-Stoyan-Stefanov/dp/0596806752) - Stoyan Stefanov (Patrones JavaScript)
  - [Pro JavaScript Design Patterns](http://www.amazon.com/JavaScript-Design-Patterns-Recipes-Problem-Solution/dp/159059908X)  - Ross Harmes and Dustin Diaz (Patrones de Diseño Avanzados en Javascript) 
  - [High Performance Web Sites: Essential Knowledge for Front-End Engineers](http://www.amazon.com/High-Performance-Web-Sites-Essential/dp/0596529309) - Steve Souders (Sitios Web de Alto Desempeño: Conocimiento Esencial para los Ingenieros de Capa de Presentación)
  - [Maintainable JavaScript](http://www.amazon.com/Maintainable-JavaScript-Nicholas-C-Zakas/dp/1449327680) - Nicholas C. Zakas (JavaScript Mantenible)
  - [JavaScript Web Applications](http://www.amazon.com/JavaScript-Web-Applications-Alex-MacCaw/dp/144930351X) - Alex MacCaw (Aplicaciones Web JavaScript)
  - [Pro JavaScript Techniques](http://www.amazon.com/Pro-JavaScript-Techniques-John-Resig/dp/1590597273) - John Resig (Técnicas Avanzadas JavaScript)
  - [Smashing Node.js: JavaScript Everywhere](http://www.amazon.com/Smashing-Node-js-JavaScript-Everywhere-Magazine/dp/1119962595) - Guillermo Rauch (Increíble Node.js: JavaScript en todas partes)
  - [Secrets of the JavaScript Ninja](http://www.amazon.com/Secrets-JavaScript-Ninja-John-Resig/dp/193398869X) - John Resig and Bear Bibeault (Secretos del JavaScript Ninja)
  - [Human JavaScript](http://humanjavascript.com/) - Henrik Joreteg (JavaScript Humano)
  - [Superhero.js](http://superherojs.com/) - Kim Joar Bekkelund, Mads Mobæk, & Olav Bjorkoy
  - [JSBooks](http://jsbooks.revolunet.com/)

**Blogs**

  - [DailyJS](http://dailyjs.com/)
  - [JavaScript Weekly](http://javascriptweekly.com/)
  - [JavaScript, JavaScript...](http://javascriptweblog.wordpress.com/)
  - [Bocoup Weblog](http://weblog.bocoup.com/)
  - [Adequately Good](http://www.adequatelygood.com/)
  - [NCZOnline](http://www.nczonline.net/)
  - [Perfection Kills](http://perfectionkills.com/)
  - [Ben Alman](http://benalman.com/)
  - [Dmitry Baranovskiy](http://dmitry.baranovskiy.com/)
  - [Dustin Diaz](http://dustindiaz.com/)
  - [nettuts](http://net.tutsplus.com/?s=javascript)

  **[[⬆ regresar a la Tabla de Contenido]](#TOC)**

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies


