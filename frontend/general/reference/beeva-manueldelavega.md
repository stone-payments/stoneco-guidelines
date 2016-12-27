  

Desarrollo Front   
Guía de proyectos y buenas prácticas   

Índice   

[1\. Introducción](#1-introducción)   
[2\. Carga inicial](#2-carga-inicial)   
  * Regla 1: Realizar pocas peticiones HTTP   
  * Regla 2: Usar CDNs (Content Delivery Network)
  * Regla 3: Añadir cabeceras de expiración
  * Regla 4: Utilizar compresión Gzip
  * Regla 5: Incluir hojas de estilos al principio del documento HTML
  * Regla 6: Incluir ficheros Javascript al final del documento
  * Regla 7: Evitar expresiones CSS
  * Regla 8: Cargar Javascript y CSS mediante archivos externos
  * Regla 9: Reducir los DNS Lookups
  * Regla 10: Comprimir Javascript
  * Regla 11: Evitar redirecciones
  * Regla 12: Evitar duplicación en ficheros Javascript importados
  * Regla 13: Correcta configuración de los ETags
  * Regla 14: Cachear ciertas peticiones AJAX

[3\. Manejo del DOM](#3-manejo-del-dom)   
  * Exceso de reflows
  * Acceso al DOM

[4\. Creación de hojas de estilos](#4-creación-de-hojas-de-estilos)   
  * Utilización de preprocesaores css  
  * Organizar los css
  * Tipos de clases css
    * Estructura
    * Estado visual
    * Entidad funcional
    * Estado funcional
  * Otras consideraciones

[5\. Desarrollo con Javascript](#5-desarrollo-con-javascript)   
  * Escribiendo código Javascript
    * Utilización de los operadores comparativos === y !==   
    * Variables
    * Uso estricto
    * Eval is evil
    * Problemas en accesos a this   
  * Programación orientada a eventos   
  * Programación funcional
  * Manejo de la asincronía
  * Conclusión

[6\. Elección del framework](#6-elección-del-framework)   
  * Portales Web
  * Aplicaciones RIA

[7\. Referencias](#7-referencias)

# 1\. Introducción

Para lograr un rendimiento óptimo en la ejecución de nuestras aplicaciones web, así como disponer de un código bien estructurado y modularizado, es conveniente seguir una serie de pautas, de las cuales se va a hablar en este apartado.   

En cuanto a la modularización/estructuración del código, se dispone de varios frameworks que ayudan a estas tareas, ofreciendo una metodología de trabajo. De entre los más conocidos de estos frameworks, cabe destacar ExtJS con una metodología basada en el patrón MVC y/o MVVM, BackboneJS con un patrón MVC o MVP, según interese y, ahora más en auge pero aún algo reciente, AngularJS, con un patrón MVVM. Cada uno de estos frameworks, de obligada utilización hoy en día, tienen sus propias guías de buenas prácticas, pero todos ellos tienen algo en común: son frameworks para desarrollo web basado en HTML con Javascript. Por tanto, en esta guía se va a hacer un enfoque más orientado a las buenas prácticas a lo que es común a ellos, o cualquier otro framework de estas características y, por otra parte, qué criterios seguir a la hora de elegir un frameworks u otro. Todo esto vamos a tratarlo en los siguientes puntos:   

*   Carga inicial de la aplicación web
*   Problemas típicos en el manejo del DOM
*   Creación de hojas de estilos
*   Desarrollo con Javascript
*   Elección del framework adecuado

# 2\. Carga inicial

La carga inicial de una aplicación web es un punto crítico, dependiendo del grueso de nuestra aplicación. En este punto es donde vamos a descargar del servidor tanto el fichero HTML como sus respectivas hojas de estilos, las imágenes incluidas en estas y los ficheros javascript. Además, se procede al renderizado en el navegador del árbol del DOM mientras va leyendo el fichero HTML. Como vemos, son varios procesos que, dependiendo de la conexión de red, de la cantidad de archivos dependientes que tenga que descargar, su tamaño y muchos otros factores, puede ser un trabajo bastante costoso en tiempo.   

Para conseguir una óptima carga inicial, vamos a ver 14 puntos en concreto básicos, que son las 14 reglas de optimización web. Estas reglas han sido extraídas del libro “High performance web sites” de Steve Souders, antiguo responsable de rendimiento de aplicaciones web de Yahoo! y actualmente desarrollando las mismas funciones en Google. Estas reglas se escribieron cuando empezó la web 2.0, algo que ha quedado quizá un poco atrás si lo comparamos con el tipo de aplicaciones web que se hacen actualmente, mucho más ricas, pero es un buen punto de partida, ya que siguen siendo válidas y se entiende bastante bien el comportamiento de la carga inicial con la explicación de cada una de ellas.   

La intención de este apartado es citar dichas reglas básicas y ofrecer una ligera explicación de cada una de ellas, para que sirva a modo de referencia rápida. Para su entendimiento con mayor profundidad, es recomendable la lectura del citado libro, donde se reflejan distintos estudios de rendimiento y explicaciones más detalladas.   

## 2.1\. Regla 1: Realizar pocas peticiones HTTP

Es obvio que, a menos cantidad de peticiones HTTP, menor será el tiempo de carga de los ficheros de nuestra aplicación, ya que se disminuyen los tiempos de latencia de red. Los ficheros a descargar son tanto nuestro HTML principal, como los archivos css, javascript y las imágenes de las que depende. Estas son las formas en las que podemos reducir el número de peticiones HTTP con respecto a estos ficheros:   

*   Ficheros Javascript: combinando los diferentes archivos Javascript externos en uno sólo. Sin embargo, hoy en día las aplicaciones web contienen una cantidad enorme de fuentes javascript, lo que puede provocar que, al combinarlos, se cree un único archivo Javascript de incluso algún que otro Megabyte. En determinados casos, es importante distinguir de los fuentes que son necesarios en la carga inicial, que son los que se deberían combinar, con respecto de los que no son necesarios para esta carga, sino que podrían ser descargados posteriormente bajo demanda, por ejemplo mediante AMD (Asynchronous Module Definition), que lo veremos más tarde en el apartado de Javascript.
*   Ficheros CSS: Igualmente combinándolos en un único fichero CSS
*   Imágenes: combinándolas mediante sprites, accediendo a cada recorte mediante la propiedad background-position de css

Los dos primeros puntos (tanto la combinación de fuentes Javascript como css) es convenientes realizarlos para despliegues en producción, pero no tanto en entornos o fase de desarrollo, ya que complicaría la depuración   

## 2.2\. Regla 2: Usar CDNs (Content Delivery Network)

Como su nombre indica, son redes de distribución de contenidos de sitios webs (documentos, imágenes, css, etc) que existen para mejorar estos tiempos de carga. Son interesantes de utilizar, en la medida de lo posible. COmo proveedores de estos servicios destacan Level 3, Akamai y Amazon CloudFront   

## 2.3\. Regla 3: Añadir cabeceras de expiración

Es muy importante la correcta gestión de estas cabeceras HTTP, para que el sistema de caché del navegador funcione correctamente. Estas cabeceras son gestionadas en nuestros servidores de aplicaciones. Por ejemplo, en los servidores Apache HTTP, disponemos del módulo mod_expires para este fin.   

## 2.4\. Regla 4: Utilizar compresión Gzip

Habilitar la compresión Gzip en nuestro servidor para archivos estáticos, reduce drásticamente el tamaño que se envía hacia el navegador a través de la red, concretamente en torno al 70% para ficheros css o javascript por ejemplo. Debe estar habilitado.   

## 2.5\. Regla 5: Incluir hojas de estilos al principio del documento HTML

Si bien es cierto, que normalmente las hojas de estilos se incluyen en el HEAD del documento HTML, es importante entender que si son incluidos en otros apartados del documento, técnicamente posible, provocaría un problema rendimiento en el renderizado del árbol del DOM, esto es, en pintar la página web. Esto es debido a que muchos navegadores bloquean el renderizado hasta conocer las propiedades de estilos de los nodos que componen el DOM, para evitar repintados o reflows (de los que se hablará posteriormente en la sección de manejo del DOM), por lo que bloquea el renderizado progresivo, que debería ser el comportamiento normal. Es importante, por tanto, que estén dentro de nuestro tag HEAD, al principio del DOM.   

## 2.6\. Regla 6: Incluir ficheros Javascript al final del documento

Al contrario que en el punto anterior, es conveniente incluir los ficheros Javascript al final del documento HTML. El problema, es que la descarga de ficheros Javascript es bloqueante, por lo que se detiene el renderizado progresivo de la aplicación web, incrementando el tiempo que transcurre desde que realizamos la petición del HTML, hasta que vemos el proceso de pintado, provocando un efecto más duradero de “pantalla en blanco” cuando los ficheros Javascript son solicitados al principio del documento. Por lo tanto, es conveniente situarlos al final del documento y esperar a la ejecución de cualquier javascript a que la carga del documento haya finalizado. Comúnmente, se ha utilizado el evento onload del tag BODY para controlar cuando la descarga del HTML se ha completado y ejecutar una función de inicialización. Esta solución, se queda un poco corta, ya que el evento se dispara cuando se ha terminado de construir y pintado hasta la etiqueta de cierre del HTML, pero no controla la descarga de imágenes que puede haber en la página. Para poder controlar la carga total, incluidas imágenes, varias librerías ofrecen métodos para este control. Por ejemplo, jQuery ofrece el método $.ready(handler), o su alias $(handler), que recibe como parámetro la función de inicialización.   

## 2.7\. Regla 7: Evitar expresiones CSS

Las expresiones CSS fueron introducidas en Internet Explorer 5 y de ahí en adelante la han implementado versiones posteriores de Internet Explorer. El resto de navegadores, las ignoran. Es conveniente no utilizarlas, ya que provocan problemas de rendimiento   

## 2.8\. Regla 8: Cargar Javascript y CSS mediante archivos externos

Debe evitarse la incrustación de css mediante la etiqueta STYLE o de código Javascript en el documento HTML. Deben ser incluidos siempre en ficheros externos.   

## 2.9\. Regla 9: Reducir los DNS Lookups

Si disponemos de ficheros fuentes que apuntan a diferentes hosts, conlleva a un aumento de tiempo en la resolución de DNSs, por lo que se puede incrementar el tiempo de carga. Sin embargo, navegadores como Firefox o Internet Explorer, sólo permiten por defecto la descarga de dos ficheros simultáneamente desde un mismo host. Aunque este comportamiento por defecto puede sobrescribirlo el usuario en las preferencias de su navegador (en el caso del Firefox) o en el registro de Windows (en el caso de IE), no podemos depender de ello, por lo que hay que buscar un equilibrio entre la reducción de resoluciones de DNS y las descargas en paralelo   

## 2.10\. Regla 10: Comprimir Javascript

Esta regla también puede aplicarse a los ficheros css. Consiste en eliminar espacios, tabulaciones, comentarios, saltos de línea, etc., de nuestros archivos (combinados mejor como vimos en la primera regla) resultando un archivo con un tamaño menor y, por lo tanto, se descargará de forma más rápida. Existe también la opción de la ofuscaciń (sólo en el caso de los ficheros Javascript), que consiste en pasar unos algoritmos que reescribe el código, haciéndolo ilegible con nombres de variables y métodos reducidos. Este paso es un tanto delicado, ya que, al contrario de la compresión o compactación, cambia el código basándose en un algoritmo y, como todo algoritmo, puede tener bugs y fallar. No suele pasar, pero hay que tenerlo en cuenta. Para estos procesos, se dispone de distintas herramientas como, por ejemplo, YUI Compressor, Uglify, Sencha SDK Tools para desarrollos con ExtJS o r.js para desarrollos en los que la gestión de dependencias sea manejada con require.js.   

## 2.11\. Regla 11: Evitar redirecciones

Las redirecciones son peticiones que vienen con un estado HTTP entre 300 y 307 (salvo el 304 que no es realmente una redirección y veremos más adelante en la regla 13) con una url alternativa. Esto provoca, al menos, dos peticiones desde el navegador. La primera petición y su respuesta con el estado 30* junto con la nueva url y una segunda apuntando a esta url. Por tanto, conlleva una pérdida de tiempo.   

## 2.12\. Regla 12: Evitar duplicación en ficheros Javascript importados

Parece una regla absurda, pero es básicamente un toque de atención, ya que muchos sitios web, muchos de ellos importantes, se les pasa por alto la inclusión de un mismo Javascript repetidas veces. En concreto, en el momento de la edición del libro, Steve Souders detectó que dos de los 10 sitios más visitados de EEUU contenían scripts duplicados. En concreto CNN y youtube. Y provoca problemas de rendimiento importantes. Hay que tener cuidado con los scripts que se incluyen, y ya no hablar de distintas versiones de un mismo fichero js (como incluir distintas versiones de jquery). ¡Cuidado con esto!   

## 2.13\. Regla 13: Correcta configuración de los ETags

Los ETags, son un sistema de control de los servidores de aplicaciones web. Sirven para controlar si la versión de un componente web cacheado por el navegador es la correcta, la más reciente. Estas comprobaciones las realiza el navegador mediante lo que se llaman peticiones GET condicionales. Cuando un servidor recibe una petición de este tipo, el servidor comprueba la fecha de expiración o los ETags. Si la versión cacheada en el navegador es la correcta, el servidor responde con un 304 (sin modificar). Por tanto, son peticiones más ligeras.  Los ETgas básicamente son una cadena de texto, que contiene más información que simplemente la fecha. por ejemplo, el servidor Apache HTTp, envía como información del ETag un identificador “inode”, el tamaño del archivo y un timestamp concatenados. El problema viene cuando disponemos de un balanceo de carga y un mismo fichero puede ser servido por distintos servidores. En estos casos, tanto el tamaño como el timestamp van a coincidir, pero no el inode, por lo que el servidor no devolverá un 304, si no que devolverá un 200 con el componente completo, desaprovechando el sistema de caché del navegador. Por tanto, cuando existan balanceadores de carga, deberán configurarse los ETags (eliminando por ejemplo en caso del servidor Apache el inode), o bien configurar los servidores para que no utilicen ETags.   

## 2.14\. Regla 14: Cachear ciertas peticiones AJAX

Al igual que las páginas HTML, los ficheros Javascript o css o las imágenes, también ciertas llamadas AJAX son susceptibles de ser cacheadas una vez realizadas, dando lugar a una mejora en la experiencia del usuario en sucesivas visitas al sitio web. Por ejemplo, si disponemos en nuestra aplicación de un historial de registros de cualquier tipo y accedemos al detalle via AJAX de uno de esos registros, este no va a ser susceptible de cambiar, por lo que, si accedemos posteriormente a él, si hubiéramos cacheado la petición con anterioridad, la respuesta sería mucho más rápida, simplemente indicándole en el header de expiración una fecha futura.   

El análisis y posterior configuración de las peticiones propensas de ser cacheadas, pueden mejorar notablemente la experiencia del usuario, mejorando los tiempos de respuesta.

# 3\. Manejo del DOM

En esta sección vamos a identificar los principales problemas de rendimiento causados por un manejo y acceso incorrecto del DOM (Document Object Model), para tratar de reducirlos y conseguir aplicaciones web más optimizadas.   

Lo primero a tener en cuenta, es que el trabajo más costoso para todo navegador es el renderizado y acceso a los nodos del DOM. Realmente, pocas veces la ejecución de código Javascript es lenta en sí misma. Es un lenguaje que, aún existiendo motores más veloces que otros, se interpreta realmente rápido. Realmente, la gran mayoría de cuellos de botella o procesos pesados en la ejecución de código Javascript viene precisamente en estos los accesos al DOM y fases de renderizado.   

Si bien es cierto que el renderizado en sí mismo no es algo que podamos evitar, ya que es absolutamente necesario, sí que existe un problema de renderizaciones extras y no necesarias que son conocidos como reflows o relayouts, que provocan problemas de rendimiento importantes en los navegadores.   

Vamos a tratar de explicar en qué consisten estos problemas y cómo solventarlos.   

## 3.1\. Exceso de reflows

Lo primero, es explicar que es un reflow o relayout. Imaginemos que disponemos del siguiente marcado en nuestra aplicación web:   

<div class=”toolbar”>   
<button class=”btn add”>Añadir...</button>   
<button class=”btn edit”>Editar...</button>   
<button class=”btn move”>Mover...</button>   
<button class=”button copy”>Copiar</button>   
<button class=”button delete”>Eliminar</button>   
</div>   

Disponemos también de un listado de registros para los cuales queremos poder realizar las acciones Editar, mover, copiar y/o eliminar y que dichos botones aumenten de tamaño cuando tengamos un elemento seleccionado en dicha lista. Si no hay elementos seleccionados, deberían volver a su tamaño original.   

Una posible solución, sería agrandar/achicar cada uno de esos botones cada vez que se recoja un evento de selección o deselección en la lista. Bien, pues aquí tendríamos un problema de reflow. Básicamente, el navegador realiza un repintado cada vez que estamos cambiando el tamaño de un botón, debido a que debe recalcular las posiciones de los distintos elementos que tengan una posición relativa. Por tanto, el navegador está realizando un repintado por cada uno de estos botones, 4 en total. Y, como hemos dicho, el repintado es la operación más costosa para el navegador. Para solucionarlo, hay distintos métodos. Uno por ejemplo, sería ocultar el div con la clase toolbar, realizar los cambios a cada uno de los botones y, posteriormente, volver a visualizar el div contenedor. El efecto de desaparición y reaparición del div sería imperceptible y habríamos logrado reducir a 2 el número de reflows (el de ocultar el div y el de volver a visualizarlo), resultando finalmente en una ejecución más rápida.   

Esto es simplemente un ejemplo intuitivo, para tratar de explicar en qué consisten los reflows para tratar de evitarlos. Cuando sea necesario realizar operaciones que afecten a posiciones, tamaños, márgenes o paddings de varios elementos, es preferible englobarlos en otro componente que podamos retirar temporalmente del árbol de renderizado para realizar estas operaciones y posteriormente volver a visualizar el componente que los englobe.   

Para un conocimiento más profundo acerca del funcionamiento de los navegadores modernos, es recomendable la lectura del artículo [How Browsers Work: Behind the scenes of modern web browsers](http://www.html5rocks.com/en/tutorials/internals/howbrowserswork/).   

Algunos frameworks como ExtJS, en lo que no se trabaja directamente contra el DOM, si no que se trabaja con objetos Javascript que posteriormente el framework se encarga de renderizar, disponen de sistemas para evitar estos excesos de reflows. En el caso de ExtJS, se dispone de los métodos Ext.suspendLayout() y Ext.resumeLayout().   

## 3.2\. Acceso al DOM

Otro de los puntos críticos en los navegadores, es en el acceso desde Javascript al DOM. Esto es, por ejemplo, recoger un determinado nodo mediante la instrucción document.getElementById(), con la función $() de jquery o cualquier método similar en otras librerías. SIn embargo son operaciones que son necesarias, pero igualmente de necesario es reducirlas. ¿Cómo las podemos reducir? Utilizando variables. Por ejemplo, para el ejemplo anterior, utilizando por ejemplo jquery, podríamos haberlo realizado de dos formas:   

```javascript
$(“div.toolbar”).hide();   
//… resto ejecución...   
$(“div.toolbar”).show();   
```

En este caso, estamos buscando dos veces el mismo nodo del DOM, lo que termina produciendo problemas de rendimiento si abusamos. Es preferible guardar una referencia al nodo en una variable, por lo que la búsqueda se hace sólo una vez:   

```javascript
var toolbar = $(“div.toolbar”);   
toolbar.hide();   
//… resto ejecución...   
toolbar.show();   
```

jQuery en concreto, ofrece también un estilo de programación en cascada, en la que cada operación sobre un nodo del DOM, devuelve una referencia de ese nodo, de forma que sólo tenemos un acceso inicial. Por ejemplo:   

```javascript
$(“div.mi-clase1”)   
.width(100) //devuelve la referencia del div anterior   
.height(200);
```

Otro problema típico de acceso lo encontramos en los bucles. Por ejemplo, si queremos recorrer los hijos de un div, podríamos hacer lo siguiente:   

```javascript
var div = $(“div.mi-clase”);   
for (var i=0; i<div.children;i++) {   
  div.children[i].innerHTML = “nodo ” + i;   
} 
```

Esto también conlleva problemas de rendimiento. Sería preferible guardar una referencia de div.children en otra variable, ya que dentro del bucle, tiene que estar accediendo en cada iteración a la propiedad children del nodo del DOM al que apunta la variable div y, por ser un acceso al DOM es especialmente lento.   

```javascript
var div, children, len;   

div = $(“div.mi-clase”);   
children = div.children; //guardamos la referencia de los hijos   
len = div.length; //guardamos también el valor de la cantidad de los hijos, para no tener   
//que acceder en cada iteración del bucle   

for (var i=0; i<len;i++) {   
  children[i].innerHTML = “nodo ” + i;   
} 
```

De esta forma, el código estaría mucho más optimizado.   

En conclusión, es preferible guardar referencias de nodos en variables y evitar accesos de lectura innecesarios.  

# 4\. Creación de hojas de estilos

Muchas veces, las hojas de estilo css suponen verdaderos quebraderos de cabeza conforme van creciendo más y más si no se atiende a una serie de reglas tanto de organización como de buenas prácticas, teniendo muchas veces que comenzar a sobreescribir reglas css o utilizar de forma indebida muchas veces el modificador !important, originando finalmente hojas de estilos mucho más pesadas de lo necesario y, por tanto, aumentando el tiempo de carga cuando se solicitan al servidor . Trataremos de ofrecer en esta sección una serie de reglas que pueden ser de utilidad   

## 4.1\. Utilización de preprocesaores css

Los preprocesadores son herramientas que aportan lenguajes para la creación de ficheros que, posteriormente, serán traducidos, originando los ficheros css necesarios para insertar en los sitios web.   

Hay distintos preprocesadores en el mercado. Los más conocidos son Sass/Compass, Less y Stylus. Todos ellos funcionan de forma similar, aportando la posibilidad de definir variables, funciones y una serie de ventajas para que, a la hora de escribir nuestro código que posteriormente será exportado a css, se realice de forma más rápida, legible y pudiendo reutilizar estas variables y funciones. En definitiva, agilizan muchísimo el desarrollo de las hojas de estilo y, finalmente, exportan unos ficheros css bastante optimizados. No obstante, la recomendación es utilizar SASS/Compass, ya que es el más extendido.   

No obstante, es conveniente tener conocimiento de buenas prácticas a la hora de escribir hojas de estilo css, para así poder aprovechar aún más la potencia de estos preprocesadores.   

## 4.2\. Organizar los css

Para poder desarrollar css de una forma más organizada, estos deben estar separados en ficheros, al menos durante la fase de desarrollo, ya que en producción deben combinarse para aligerar el número de peticiones del navegador, como se vio en la [primera regla](https://docs.google.com/document/d/1oq6x-s6riZlSa4fxXyGQR-gQbdZdVUlG9ReTzzZepUk/edit#heading=h.dgyksl1vnpea) del apartado “ [carga inicial](https://docs.google.com/document/d/1oq6x-s6riZlSa4fxXyGQR-gQbdZdVUlG9ReTzzZepUk/edit#heading=h.w8jtjti4l3gc)”.   

Un buen criterio para organizar los ficheros css de desarrollo puede ser agruparlos según dos variantes:   

*   De componentes reutilizables genéricos
*   De componentes funcionales de la aplicación

Los componentes reutilizables son todos aquellos que no son propios en sí de la aplicación que estemos desarrollando, sino que pueden utilizarse en diversas aplicaciones. Estos son por ejemplo los css para los grids de datos, comboboxes, árboles y demás widgets o componentes reutilizables. Muchas veces, estos componentes vienen dados por frameworks o librerías externas, los cuales sobreescribimos o reescribimos completamente, según necesidades, aunque también pueden ser nuestros propios componentes estructurales que queramos reutilizar en otros proyectos. Es importante, sobre todo en este último punto, esta separación, pues nos permitirá tener más independizadas las reglas de estilos de estos componentes nuestros, por lo que nos será más sencillo reutilizarlos en otras aplicaciones o sitios web.   

Otros componentes, son los funcionales, que digamos son las distintas páginas de un sitio web tradicional basado en un patrón de múltiple páginas, o los distintos módulos funcionales en aplicaciones que sigan un patrón de una única página o SPA (Single Page Application), por ejemplo, en una aplicación de gestión de cursos, podríamos tener un módulo de alumnos, con todo el css que estuviera relacionado con este módulo situado en un fichero alumnos.css.   

## 4.3\. Tipos de clases css

Es importante que nuestras reglas de css tengan un carácter semántico, de forma que sean muy intuitivas. Para ello, podemos agrupar las clases css en cuatro tipos:   

*   De estructura
*   De estado visual
*   De entidad funcional
*   De estado funcional

### 4.3.1\. Estructura

Las clases css de estructura son aquellas que hacen referencia a componentes reutilizables en distintos aplicaciones o sitios web. Vuelven a ser nuestros componentes reutilizables. Estos deben tener una única clase css que les hiciera referencia. Por ejemplo, si empleamos dos grids de datos en nuestra web, nunca deberíamos tener una clase grid-primero y otra clase grid-segund, sino que ambas deberían tener  una misma clase css, por ejemplo, data-grid. Pero, ¿qué pasa si queremos que uno de estos grids de datos se visualice de forma distinta del anterior? Ahí es donde entra y debemos aprovechar la potencia de las reglas de estilos. Normalmente, si queremos que un componente de un tipo se visualice de una forma distinta de otro del mismo tipo, suele ser debido a algún requerimiento de tipo funcional, ya sea por tener un estado en concreto o por pertenecer a una entidad determinada. Vamos a ver un ejemplo más concreto en el siguiente punto.  

### 4.3.2\. Estado visual

El estado de visualización, como su nombre indica, es la forma en la que se va a visualizar un componente de cualquier tipo (de estructura o entidad) en función de un estado determinado. Los estados más comunes son:   

*   seleccionado
*   deshabilitado
*   con la propiedad focus
*   con la propiedad hover (por ejemplo en botones, enlaces, la fila de un grid de datos…)
*   oculto
*   editable

Como se puede apreciar, no aparecen los estados deseleccionado, habilitado, oculto ni no editable, ya que podemos considerar que un componente en su estado normal posee estas características.   

Volviendo al ejemplo del caso anterior, podemos por ejemplo tener el caso en el que tengamos dos grids y la diferencia pudiera ser el estado de visualización, uno habilitado y otro deshabilitado. Pues, en vez de tener dos clases css, una grid-normal y otra grid-disabled, podríamos utilizar una única clase data-grid y utilizar el estado como modificador:   

```html
<table class=”data-grid”>   
<tr>   
<td><span>columna 1<span></td>   
<td>columna 2</td>   
</tr>   
</table>   
<table class=”data-grid disabled”>   
<tr>   
<td><span>columna 1</span></td>   
<td>columna 2</td>   
</tr>   
</table>   
```

Y en nuestro css, tendríamos las propiedades genéricas para el data-gird y, en el modificador según el estado, bastaría con sobrescribir lo necesario:   

```css
table.data-grid {color: #000; width: 100%;}   
table.data-grid .disabled {color: #CCC;}   

Y lo mismo para los nodos que dependan de él, como el span   

table.data-grid {color: #000; width: 100%;}   
table.data-grid span {font-weight: bold;}   

table.data-grid.disabled {color: #CCC;}   
table.data-grid span {font-weight: normal;}   
```

Pero también, podríamos querer que no sólo dependiera del estado de visualización, sino que en distintas pantallas, queremos que se visualizara de forma distinta, en función del tipo de pantalla, lo que tiene un carácter  funcional, lo cual vamos a tratar a continuación.   

### 4.3.3\. Entidad funcional

Estas pueden ser tanto para hacer referencia a entidades determinadas (Alumnos, cursos, profesores…), como entidades más globales, como podría ser un módulo de administración. En el siguiente ejemplo vamos a ver cómo podríamos diferenciar los grids de datos de un módulo de administración de los del resto de la aplicación:   

```html
<!-- Módulo de administración -->   
<div class=”administration”>   
<table class=”data-grid”>   
<tr>   
<td><span>columna 1<span></td>   
<td>columna 2</td>   
</tr>   
</table>   
<table class=”data-grid disabled”>   
<tr>   
<td><span>columna 1</span></td>   
<td>columna 2</td>   
</tr>   
</table>   
</div>   

<!-- Otro módulo -->   
<div class=”administration”>   
<table class=”data-grid”>   
<tr>   
<td><span>columna 1<span></td>   
<td>columna 2</td>   
</tr>   
</table>   
<table class=”data-grid disabled”>   
<tr>   
<td><span>columna 1</span></td>   
<td>columna 2</td>   
</tr>   
</table>   
</div>   
```

Pues bastaría con hacer depender jerárquicamente las reglas en función de estas entidades:   

```css
/* Grid genérico */   

table.data-grid {color: #000; width: 100%;}   
table.data-grid span {font-weight: bold;}   

table.data-grid.disabled {color: #CCC;}   
table.data-grid span {font-weight: normal;}   

/* Módulo administración */   

.administration table.data-grid {color: #fff;background: #000; }   
```

Simplemente sobrescribimos lo que nos interese, manteniendo el resto de reglas por defecto, tanto para los spans que contiene, como para el estado deshabilitado, pudiendo también ser sobrescritas si interesase.   

Para que estas clases sean útiles, deben estar situadas en el nodo HTML superior, el padre de mayor nivel que englobase al resto, para no tener que ser repetida en el HTML. Deben estar incluídas una única vez. En cambio, en el css, cualquier regla que dependa de esta clase, debe reflejarlo en la regla css. Por ejemplo:   

```html
<div class=”usuario”>   
<form class=”form-usuario”>   
…   
</form>   
</div> 
```

En el css:   

```css
.usuario {font-size: 14;}   
.form-usuario {padding: 5px;}   
```

Esto sería incorrecto. Si queremos indicarle al formulario una clase, no debería de contener nada referente a usuario. En su lugar, debería acceder a través de la jerarquía de clases:   

```html
<div class=”usuario”>   
<form>   
…   
</form>   
</div> 
```

En el css:   

```css
.usuario {font-size: 14;}   
.usuario form {padding: 5px;}   
```

o, si queremos darle una clase especial al formulario, para que esta regla no se aplique a todos los formularios:   

```html
<div class=”usuario”>   
<form class=”registro”>   
…   
</form>   
</div> 
```

En el css:   

```css
.usuario {font-size: 14;}   
.usuario form {padding: 5px;}   
.usuario form.registro {font-size: 11px;}   
```

De esta forma, todos los formularios dependientes de la clase usuario tendrían un tamaño de fuente de 14px y un padding general de 5px, salvo el formulario de registro, que sobrescribirá el tamaño de fuente.   

### 4.3.4\. Estado funcional

Por último, tendríamos las clases css de estado funcional, que hacen referencia a los distintos estados que pudiera tener una entidad determinada. Por ejemplo, imaginemos un workflow de un mensaje, en el que queramos representar la información de la cabecera del mensaje de una forma distinta en función de los estados, como la fecha de envío, de lectura en su caso, un icono para cada estado, emisor y remitente. Aquí podríamos tener un montón de nombres de clases css distintas: en cuanto a iconos: ico-enviado, ico-recibido, ico-leido.. Y lo mismo para los demás campos. Una forma sencilla y semántica, sería añadir ese estado como modificador de la clase css que representa la entidad funcional, vista en el punto anterior, definiendo reglas para el estado normal de cada camp. Por ejemplo, vamos a centrarnos en el campo del icono:   

```html
<div class=”mensaje recibido”>   
<span class=”emisor”>Fulanito</span>   
<span class=”receptor”>Menganito</span>   
<span class=”fecha-envio”>12/12/2013</span>   
<span class=”fecha-recepcion”>-</span>   
<span class=”ico”>-</span>   
</div>   
```

En el css…   

```css
/*Definimos primero las características generales para los iconos de los mensajes. Un apunte: utilizar sprites para las imágenes para reducir llamadas al servidor*/   

.mensaje span.ico {   
display: inline-block;   
width: 20px;   
height: 100%;   
background-image: url(‘sprite_path’);   
}   

/*Y ahora definimos las posiciones de las imágenes según el estado el mensaje*/   

.mensaje.enviado span.ico {background-position: 0 0}   
.mensaje.recibido span.ico {background-position: 0 20px}   
.mensaje.leido span.ico {background-position: 0 40px}   
```

De esta forma, no hay que crear gran cantidad de clases css, creando archivos bastante optimizados, reutilizables y fáciles de mantener.   

## 4.4\. Otras consideraciones

Además de las reglas visto anteriormente, hay que evitar en la medida de lo posible utilizar el modificador !important y/o la propiedad style de los nodos del DOM.   

En cuanto a la propiedad style, muchas veces es imprescindible su uso. Por ejemplo, es imprescindible para muchos frameworks a la hora de proporcionar atributos dinámicos como el width, height, etc. para poder ofrecer un dinamismo y/o flexibilidad en los componentes. Sin embargo, lo que hay que evitar es indicar en esta propiedad atributos de estilos constantes. Todo lo que sea constante debe ir en su archivo css correspondiente.   
Y, para el modificador !important, también hay veces en el que se hace imprescindible. Por ejemplo, en estos casos en los que los frameworks acceden a la propiedad style y modifican un atributo determinado, que por cualquier circunstancia, nosotros queremos que sea constante y lo tenemos definido en nuestro css. Como lo que se incluya en la propiedad style prevalece sobre las clases definidas en el css como norma general, sólo podemos hacerlo haciendo uso de este modificador, prevaleciendo el valor indicado en nuestra hoja de estilos, pero debe limitarse su uso en la medida de lo posible.   

Otra medida que puede resultar muy útil, para no tener que incluir hojas de estilos específicas para cada navegador, es añadir mediante Javascript una clase css al nodo BODY del DOM, que haga referencia al navegador. Por ejemplo:   

Para IE7   

```html
<html>   
<head>   
...   
</head>   
<body class=”ie v7”>   
</body>   
</html>   

Para chrome   
<html>   
<head>   
...   
</head>   
<body class=”chrome”>   
</body>   
</html>   
```

De esta forma, podemos tener clases genéricas que sean cross-browser y sobrescribir únicamente lo necesario en función del navegador   

```css
/*Genérico*/   
.data-grid {padding: 4px;}   

/*Para IE7*/   
.ie.v7 .data-grid {padding: 2px;}
```


# 5\. Desarrollo con Javascript

Como vimos en la introducción de esta guía, para un desarrollo bien organizado y estructurado en las aplicaciones web que se construyen hoy en día, es altamente recomendable la utilización de algunos de los frameworks de desarrollo web que proporcionan distintos patrones de diseño, tipo MVC, MVP o MVVM, como son ExtJS, BackboneJS y/o AngularJS. Cada uno de estos tienen sus propias buenas prácticas, por lo que este apartado va a estar más centrado en definir unas buenas prácticas en lo que se refiere a Javascript de una forma más agnóstica, independientemente del framework que se utilice, indicando algunos consejos básicos. No obstante, para un entendimiento más en profundidad del lenguaje, es muy recomendable la lectura del libro “Javascript: the good parts”, escrito por Douglas Crockford ( [www.crockford.com](http://www.crockford.com)), actual arquitecto de Javascript de PayPal, creador de herramientas como JSLint y también conocido por ser quien popularizó el formato de datos JSON. Este libro podría ser bien considerado como la biblia de Javascript.   

## 5.1\. Escribiendo código Javascript

Lo imprescindible para facilitar la codificación en este lenguaje, es disponer de un buen IDE. Existen varios plugins para eclipse, de entre los cuales para mi gusto destaca SPKet, pero realmente, no hay ninguno que sea lo suficientemente potente. Hay que irse a otros editores, que ya nos darán muchas más facilidades básicas para un desarrollo cómodo, como navegación entre métodos, clases, completado de código, etc. En concreto, los más utilizados hoy en día son los siguientes:   

*   Sublime Text: Esta sería la opción Open Source. Dispone de numerosos plugins que aportan las características anteriormente comentadas
*   Cloud 9 IDE: Se trata de un editor en la nube ( [www.c9.io](http://www.c9.io) ) muy potente y que nos facilita para trabajar con Javascript, tanto para aplicaciones Front como para aplicaciones Back con NodeJS, entre otros lenguajes. EL problema es que el código debe de estar en repositorios públicos como GitHub o en su sitio. Aunque disponen de cuentas privadas (de pago), seguramente muchas veces no es la opción más recomendable o posible en nuestro día a día.
*   WebStorm: Bajo mi punto de vista, es el editor de Javascript más potente que existe en el mercado. Permite un sinfín de posibilidades. Es el editor para tecnologías Javascript (NodeJS y desarrollo de sitios web con Javascript) de JetBrains y posee multitud de plugins y soporte para los frameworks más conocidos como AngularJs, ExtJS, etc. Posee además una herramienta de depuración muy potente. Esta herramienta dispone de modalidades de pago y gratuitas, en función del uso que se vaya a hacer de él ( [http://www.jetbrains.com/webstorm/buy/index.jsp](http://www.jetbrains.com/webstorm/buy/index.jsp) )
*   Google Chrome Developer Tools: Desde hace unas versiones, la herramienta de desarrollo de Google Chrome ofrece la posibilidad de crear Workspaces, incluyendo nuestros directorios de trabajo físicos y pudiendo editarlos. Ofrece excelentes herramientas de depuración, así como navegación entre fuentes (con el atajo May+o), búsqueda de métodos en una clase (atajo May+Ctrl+o), autocompletado de código… Un excelente editor también. Aún no siendo el editor principal en el desarrollo de un proyecto, su uso se hace indispensable, ya que aporta muchísima información de utilidad a la hora de realizar análisis de código con los profilers, tiempos de carga, etc. También son interesantes para este mismo propósito las herramientas de desarrollo de Firefox o el Development ToolBar de Internet explorer (del que es muy interesante la herramienta de creación de profiles, en la que se pueden descubrir cuellos de botellas y problemas de rendimiento en este navegador).

Otras herramientas que se convierten en grandes aliadas cuando escribimos código en javascript son los validadores de sintaxis. Los más conocidos son JSLint (mencionado anteriormente) y JSHint. Los dos son excelentes validadores de sintaxis, aunque podemos decir que JSHint es un poco más permisivo. Existen tanto herramientas que nos evalúan constantemente la sintaxis utilizando uno u otro validador. WebStorm la incorpora y sólo es necesario activarla y configurarla.   

También puede activarse utilizando GruntJS. Esta herramienta consiste en un ejecutor de tareas. Está escrito en Javascript y corre sobre NodeJS. Podemos instalar en nuestro proyecto multitud de plugins para realizar muchas operaciones, como compresión de código, lanzamiento de tests y, entre otras más, lanzar los validadores de sintaxis, en tiempo real mientras estamos codificando (con una tarea que se denomina watch) o bajo demanda cuando lo deseemos.   

También existen plugins para maven, por ejemplo, para que sea lanzado cuando compilamos nuestro war o ear en un entorno de desarrollo JAVA.   

La utilización de GruntJS es también bastante recomendada en el desarrollo, ya que dispone de una gran cantidad de plugins para montones de tareas, incluso pudiendo escribir nuestros propios módulos para tareas personalizadas. Para más información se puede visitar su sitio web [http://gruntjs.com/](http://gruntjs.com/).   

Algunos de las buenas prácticas en sintaxis de las que nos advierten estos validadores, y que son importantes comprender, son las siguientes:   

### 5.1.1\. Utilización de los operadores comparativos === y !==

Todos sabemos que Javascript es un lenguaje débilmente tipado. Estos son los tipos de datos primitivos en Javascript (los que obtenemos al hacer un typeof variable):   

*   undefined
*   number
*   function
*   object
*   xml
*   string
*   boolean

Cuando utilizamos los comparadores == y !=, al realizar la comparación se ignoran estos tipos. Sólo se tiene en cuenta el valor. Por ejemplo   

```javascript
1 == 1 //true   
“1” == 1 //true
```

Sin embargo, si utilizamos los compradores estrictos === y !==, también el tipo es comparado. En este caso   

```javascript
1 === 1 //true   
“1” === 1 //false
```

Esto puede evitarnos muchos problemas. Aún siendo un lenguaje débilmente tipado, es nuestra responsabilidad evitar problemas cuando realizamos comparaciones, por lo que es importante utilizar siempre los operadores de comparación estrictos === y !==.   

### 5.1.2\. Variables

En Javascript, el ámbito de las variables es global o de función. No existe el ámbito de bloque. Esto quiere decir lo siguiente:   

```javascript
var miFuncion = function () {   
  if (true) {   
    var value = 1;   
  }   
  alert(value);   
}   
```

Si ejecutamos esta función, el alert mostrará siempre 1, aún estando definida y declarada la variable dentro de un bloque. Esto es debido a que el intérprete de Javascript “sube” las declaraciones de las variables a lo alto de la función. El método anterior realmente quedaría así:   

```javascript
var miFuncion = function () {   
  var value;   
  if (true) {   
    value = 1;   
  }   
  alert(value);   
}   
```

También es significativo el siguiente caso:   

```javascript
var miFuncion = function () {   
  alert(a.prop);  //se puede observar que al ejecutarse lanza la excepción:   
  //Reference error: a is not define   
}
```

En cambio, el error que nos lanzaría el siguiente método es distinto:   

```javascript
var miFuncion = function () {   
  alert(a.prop);  //se puede observar que al ejecutarse lanza la excepción:   
  //a is not defined   
  var a;   
}   
```

En el primer caso, la excepción lanzada nos indica que a no ha sido declarada. Sin embargo, en el segundo caso nos indica que no ha sido definida, pero sí declarada, ya que el intérprete sube las definiciones de las variables a lo alto de la función:   

```javascript
var miFuncion = function () {   
  var a;   
  alert(a.prop);  //se puede observar que al ejecutarse lanza la excepción:   
  //a is not defined   
}   
```

Es importante tener esto en cuenta. Por ello, en Javascript las variables se suelen declarar todas lo más arriba de la función, normalmente combinańdolas en un mismo estamento var, para evitar problemas.   

```javascript
var miFuncion = function (param) {   
  var a, b, c, d, d; //declaramos todas las variables que vayamos a utilizar   

  if(param) {   
    a = 1;   
    b = 2;   
    c = 3;   
  } else {   
    a = 11;   
    b = 12;   
    c = 13;   
    d = 14;   
  }   
}   
```

Es importante también, tener en cuenta que en Javascript las funciones son también variables (por eso existe el tipo function). Por eso es también aconsejable declarar los métodos no anónimos como variables y declararlas al inicio de una función:   

```javascript
var miFuncion = function (param) {   
  var miFuncion2;   
  
  miFuncion2 = function () {   
    alert(“Se ha ejecutado miFuncion2”);   
  }   
  
  if(param) {   
    miFuncion2();   
  }   
}   
```

Y, ¿qué pasa con las variables de ámbito global? Estas variables pueden ser muy problemáticas, por una particularidad del lenguaje. Si asignamos un valor primitivo a una variable dentro de una función sin haberla declarado, esta pasa automáticamente a ser global:   

```javascript
var miFuncion = function () {   
  a = 3;   
}   

alert(a) // indica un alert con valor 3
```

Evidentemente, esto es problemático. Por eso, se debe tratar también de declarar todas las variables en lo más alto de la función. Muchos editores avisan cuando estamos definiendo variables globales, aunque hay otro método, que es provocar (al menos en navegadores modernos) que se produzca un error al ejecutarse el código. Esto lo conseguimos con la sentencia “use strict” la cuál cuando no es soportada por el navegador, la ignora, ya que se trata de un string y, cuando sí es soportada, obliga al navegador a ejecutar javascript de forma estricta, limitando problemas de este tipo (y además se ejecuta más rápido el javascript). Si ejecutamos:   

```javascript
(function () {   
  “use strict”;   
  a = 4;   
})(); //se autoejecuta la función
```

Nos lanzaría un error.   

Si bien es cierto que hay que tratar de evitar las variables globales, no siempre es posible. Por ejemplo, jQuery pone a disposición la variable global $, ExtJS la variable global Ext… pero lo importante es que mantienen todo el acceso a sus métodos, objetos, etc. bajo un único namespace. Una buena práctica en nuestras aplicaciones, si necesitamos variables globales para temas de configuración o de cualquier tipo, es que estén bajo un mismo dominio o namespace. Por ejemplo, en vez de tener las siguientes 4 variables globales (incluida una función):   

```javascript
var serverPath = “server”;   
var contextPath = “/miContexto”;   
var usuario = “usuario”;   
var funcionInicio = function () {...}   

//Podemos tener un único namespace para toda la aplicación utilizando un objeto Javascript:   

var MyApp = {};   

MyApp.usuario = “usuario”;   
MyApp.contextPath = “/miContexto”;   
MyApp.serverPath = “server”;   
MyApp.functionInicio = function () {...}
```

### 5.1.3\. Uso estricto

En el anterior punto, hemos visto que la utilización de la sentencia “use strict” nos ayuda a evitar ciertos problemas. Debe ser de obligado uso, siempre que se pueda, ya que algunos frameworks y, en concreto ExtJs o Sencha Touch, lanzan errores de ejecución, y que no están escritos en modo estricto. Debemos utilizarlo siempre y cuando se pueda.   

### 5.3.4\. Eval is evil

El método eval() nos permite ejecutar código Javascript que le pasemos por parámetro como un string. Debe evitarse la utilización de este método y buscar vías alternativas cuando queramos ejecutar una lógica determinada. El método eval llama internamente al intérprete de Javascript cada vez que se llama, lo que provoca problemas de rendimiento. También puede acarrear problemas de inyección de código. Debe evitarse. Un caso típico donde se utiliza, es cuando queremos acceder a la propiedad de un objeto en una determinada función, recibiendo como parámetro el nombre de la propiedad. Por ejemplo:   

```javascript
var alumnos, getProperty;   

//alumnos se un objeto que contiene datos de cada alumnos, agrupados por su identificador   

alumnos =  {   
  AL1 : {   
    nombre : “Juan”,   
    apellidos : “Martínez Campos”   
  },   
  AL2 : {   
    nombre : “Manuel”,   
    apellidos : “López Sánchez”   
  },   
};   

/**   
 * Muestra el valor de la propiedad determinada de un alumno recibido por parámetro   
 * @param {String} idAlumno   
 * @param {String} propertyName   
 */   
getProperty = function (idAlumno, propertyName) {   
  //ejecutamos un alert que aparezca el valor de alumnos.alumno.propiedad   
  alert(eval(“alumnos.” + idAlumno + “.” + propertyName));   
}   

//ejecutamos   
getProperty(“AL1”, “nombre”); //ejecutará alumnos.AL1.nombre   
```


Pero, ¿y si quisiéramos (y debemos) comprobar que el identificador del alumno es válido y está presente en el objeto? Tendríamos que reescribir el método getProperty de la siguiente forma:   

```javascript
getProperty = function (idAlumno, propertyName) {   
  var alumno;   
  alumno = eval(“alumnos.” + idAlumno);   
  if(alumno) {   
    alert(eval(alumno + “.” + propertyName));   
  } else {   
    alert(“No se encontró el alumno.”);   
  }   
}   
```

Esto implica que el intérprete se ejecute dos veces, provocando problemas de rendimiento. Además, es poco legible. La alternativa correcta sería la utilización de acceso a propiedades de objetos alternativa: utilizando los corchetes [“string”]. El método quedaría de la siguiente forma:   

```javascript
getProperty = function (idAlumno, propertyName) {   
  var alumno;   
  alumno = alumnos[idAlumno]; //alumos[“AL1”] es equivalente a alumnos.AL1   
  if(alumno) {   
    alert(alumno[propertyName]);   
  } else {   
    alert(“No se encontró el alumno.”);   
  }   
}   
```

Mucho más legible y optimizado.   

Como en este ejemplo, siempre hay una alternativa a utilizar eval. Debe utilizarse la alternativa.   

El método setTimeout o setInterval, también pueden utilizar eval internamente, si reciben como parámetro un string. Deben recibir métodos:   

```javascript
var miFunction () {   
  alert(“Mi función”);   
}   

setTimeout(“miFuncion()”, 1000) //mal   
setTimeout(miFuncion, 1000) //bien. Nótese que no se indican los paréntesis, pues si se   
// indicasen, la función sería ejecutada en el momento   
// y no esperaría el segundo indicado en la función   
// setTimeout
```

### 5.3.5\. Problemas en accesos a this

En Javascript, igual que en otros lenguajes, this es la forma de acceder al ámbito de una clase (en Javascript objetos, ya que no existe el concepto de clase en Javascript). Sin embargo, en determinadas ocasiones podemos tener problemas a la hora de utilizar this para acceder a un determinado objeto. Estos problemas son debidos a un problema de definición del lenguaje en determinadas y al ámbito donde se ejecutan distintas funciones.   

En cuanto al primer caso, existe un problema de definición del lenguaje, que provoca que cuando, dentro de un método de un objeto creamos otro método y tratamos de acceder al this dentro de esto, this hace referencia al objeto window, en vez de al objeto en cuestión. Veámoslo con un ejemplo:   

```javascript
var obj = {   
  checkThis : function () {   
    alert(this.access);   
  },   
  access : “Acceso correcto”   
};  

obj.checkThis();   
```

En este caso, observamos que aparece una alerta con el texto “Acceso correcto”, como era de esperar. Sin embargo, si ejecutamos el siguiente código:   

```javascript
var obj = {   
  checkThis : function () {   
    var showAccess = function () {   
      alert(this.access); //this en este caso es el objeto window   
    }   
    showAccess();   
  },   
  access : “Acceso correcto”   
};  

obj.checkThis();   
```

Sin embargo, ahora obtenemos una alerta que indica undefined, ya que this hace referencia al objeto window. Existe un workaround para solventar este problema, que es arropar this en otra variable. Esta variable, normalmente suele ser declarada como that, self o me:   

```javascript
var obj = {   
  checkThis : function () {   
    var that = this; //en este caso la declaramos como that   
    var showAccess = function () {   
      alert(that.access);   
    }   
    showAccess();   
  },   
  access : “Acceso correcto”   
};   

obj.checkThis();   
```

De esta forma evitamos el  problema.   

También podemos encontrarnos con el problema de que la función se ejecute dentro de otro ámbito. Por ejemplo, en jQuery podríamos tratar de hacer lo siguiente en el manejador de un evento:   

```javascript
$(function () { //cuando el documento esté cargado   
  var handlers = {};   
  //supongamos que queremos definir un manejador para todos los eventos click   
  //de los botones de la aplicación   
  handlers.attribute = “miAtributo”   
  handlers.initHandler = function () {   
    $(“button”).click(function (evt) {   
      alert(this.attribute);   
    })   
  };   
});   
```

Esta ejecución lanzará una excepción, ya que intentará buscar la propiedad attribute dentro del scope del objeto jQuery que encapsula al nodo DOM del botón. Este problema, no es exactamente igual al anterior. Para entender lo que está pasando, hay que entender el comportamiento del patrón observer que está implementado. Básicamente, en un patrón observer, se dota a un determinado objeto de una colección, donde se van apilando distintos objetos de los que quieren observarse determinados comportamientos. Cuando accedemos al método click del objeto jQuery, estamos añadiendo la función pasada por parámetro a esa colección y, cada vez que se lance el evento, va a ser ejecutada dentro del ámbito del objeto en el que se ha implementado el patrón, es decir, en el objeto jQuery.   

Para resolverlo, algunas librerías permiten pasar un parámetro adicional, que sería el scope donde se desea ejecutar la función. Otras, proporcionan métodos auxiliares para enlazar la ejecución del método al de un objeto en concreto. Por ejemplo, underscoreJS, proporciona el método bind():   

```javascript
$(function () { //cuando el documento esté cargado   
  var handlers = {};   
  //supongamos que queremos definir un manejador para todos los eventos click   
  //de los botones de la aplicación   
  handlers.attribute = “miAtributo”   
  handlers.initHandler = function () {   
    $(“button”).click(_.bind(function (evt) {   
      alert(this.attribute);   
    }, this)); //con .bind() enlazamos la ejecución de la función a this,   
    //que es el objeto handler   
  };   
});
```

Sin embargo, una solución más sencilla, es utilizar el mismo workaround del problema anterior:   

```javascript
$(function () { //cuando el documento esté cargado   
  var handlers = {};   
  //supongamos que queremos definir un manejador para todos los eventos click   
  //de los botones de la aplicación   
  
  handlers.attribute = “miAtributo”   
  handlers.initHandler = function () {   
    var that = this;   
    $(“button”).click(function (evt) {   
      alert(that.attribute); //¡solucionado!   
    });   
  };   
});   
```

En principio, cualquier solución es válida, pero por consistencia, es preferible utilizar la misma solución para ambos problemas.  

## 5.4\. Programación orientada a eventos

En nuestro caso, la mayoría del código Javascript que codificamos sirve para atender a las necesidades de un usuario que va a ser uso de una aplicación, interactuando con los distintos componentes que contenga la aplicación. Por tanto, los flujos que se vayan a producir en la aplicación no son secuenciales, sino que contienen un carácter aleatorio. Esto que parece una obviedad, debe reflejarse en nuestro código. Muchas veces, tratamos de desarrollar un código completamente secuencial a la hora de crear por ejemplo nuestros propios módulos o widgets, de forma que cuando queremos tratar un mismo módulo pero de formas distintas, muchas veces nos vemos obligados a duplicar código o hacer secuencias de código infernales y difíciles de leer y, por tanto, de mantener.   

Cuando desarrollamos una aplicación web o cualquier tipo de aplicación en la que el flujo de la misma no sea secuencial, hay que realizar un desarrollo orientado a eventos, de forma que encapsulemos los distintos módulos u objetos que creemos, haciéndolos independientes de otros y del flujo que siga el usuario. Estos objetos simplemente deben notificar qué está pasando en ellos para que otros objetos distintos esten al tanto (suscritos a ellos) de lo que les está pasando, siempre y cuando les interese a estos otros objetos.   

Pongamos el caso de un listado de usuarios. Este listado de usuarios puede querer ser reutilizado tanto para seleccionar un usuario para editarlo, tanto haciendo doble click, como abriendo un menú contextual o pulsando en un posible botón “seleccionar”, abriendo su correspondiente módulo de edición, o bien para añadir el usuario a, por ejemplo, un listado de cursos adonde se desea inscribir, con las mismas acciones descritas anteriormente.   

En un ámbito secuencial, tendríamos que escuchar los distintos eventos del botón de editar, del menú contextual y del docle click del listado y, en su función manejadora preguntar si la lista se ha abierto para añadir usuarios un curso o para editarlo. Si quisiéramos utilizar esta lista para otros fines en la aplicación, habría que aumentar el número de condiciones.   

Evidentemente, este procedimiento no es el más adecuado, ya que contaminamos nuestro módulo con código externo de otros, lo que hace que el componente no pueda ser reutilizable.   

Para evitar este problema, está el desarrollo orientado a eventos. Básicamente, lo que hacemos es que nuestro módulo expone al exterior qué está pasando. En nuestro caso, que se ha seleccionado un usuario, tanto con el doble click, con hacer click en el botón seleccionar como con el elemento “Seleccionar” del menú contextual. En los tres casos, podríamos simplemente decir un “usuarioSeleccionado”, añadiendo los datos del usuario seleccionado. Por así decirlo, el módulo de usuarios lanza o tira otro objeto u objetos para que los recoja quien le interese. De hecho, es importante que nuestros módulos notifiquen en forma de eventos qué les está pasando, independientemente de que alguien vaya a estar o no a la escucha. Cualquier cosa que pensemos que puede ser relevante debe publicarse, para que un posible suscriptor esté a la escucha y utilice esa información. Esto hará de nuestros módulos, unos módulos reutilizables al 100%. Ya corre a cargo del componente que se suscriba realizar la lógica necesaria (abrir una ventana de edición, añadir el usuario a un curso o lo que sea), escribiendo la lógica en el componente interesado.   

Todos los frameworks de desarrollo web, ofrecen herramientas para dotar a objetos de la cualidad de implementar el patrón observer.   

Sin embargo, hay que tener claro cuándo utilizar eventos y cuándo no. Vamos a verlo gráficamente. Supongamos que disponemos de 3 objetos A, B y C. Tanto A como B contienen en su interior una referencia al objeto C:   

![](https://docs.google.com/a/beeva.com/drawings/d/sWUGc5gHex86lSNkkuXu_CQ/image?w=612&h=267&rev=1&ac=1)  

Cuando A o B quieran acceder a alguna propiedad de C o ejecutar algún método suyo, no tiene sentido utilizar eventos, sino que se debe acceder directamente:   

A.C.método();   
B.C.método();   

Es cuando A o B quieran hacer algo en función de lo que pase en C. En vez de tener referencias en C de A o B, lo que hace es lanzar o exponer un evento, para que A y/o B hagan algo en este caso, de forma que el código de C es exactamente igual existan A, B, D o los objetos que se necesiten.  

## 5.5\. Programación funcional

Aún no siendo Javascript o lenguaje de programación puramente funcional, debido a ciertas características del lenguaje sí que pueden utilizarse ciertas características de lenguajes funcionales para facilitarnos la vida. Y esto es precisamente gracias a la capacidad del lenguaje de tanto recibir funciones como parámetro de otras funciones y que estas sean capaces de retornar otras funciones (que son conocidas como closures), así como que las funciones sean tipos primitivos. Debido a esta capacidad, muchos frameworks y librerías han implementado las funciones básicas de programación funcional para manejo de Arrays. Estas son:   

*   map: ejecuta un método para cada uno de los elementos de una colección y devuelve un array con los elementos resultantes.
*   filter: devuelve otra colección con los elementos que hayan cumplido cierto criterio basado en la lógica de una función que se le pasa como parámetro
*   reduce: en función de un array y otro parámetro, ejecuta una función devolviendo un resultado.
*   any: en función de un array y una función que se ejecuta para cada uno de los elementos, devuelve si al menos uno de ellos cumple con la lógica de la función pasada. Devuelve un booleano indicando si al menos uno de ellos ha cumplido la condición.
*   all: en función de un array y una función que se ejecuta para cada uno de los elementos, devuelve si todos y cada uno de ellos cumplen con la lógica de la función pasada. Devuelve un booleano indicando todos y cada uno de ellos han cumplido la condición.
*   partial: recibe una función y otro parámetro que influye en la lógica de la función pasada como primer parámetro

En las distintas librerías o frameworks, pueden llamarse de distintas formas. Suelen estar como funciones auxiliares de Arrays o colecciones y nos ayudan a escribir un código mucho más legible y que escribamos mucho menos código, siendo muy importante en el desarrollo front, ya que es muy común trabajar con colecciones (sobre todo de nodos del DOM). Un ejemplo utilizando map:   

```javascript
var collection, treatment;   
collection = [1,2,3,4];   
treatment = function (element) {   
  return element * 2;   
}   
map(collection, treatment); //devolvería [2,4,6,8]   
```

Para más ejemplos, se puede visitar esta url con dispositivas bastante ilustrativas: [http://www.slideshare.net/leo.soto/javascript-funcional](http://www.slideshare.net/leo.soto/javascript-funcional)  

## 5.6\. Manejo de la asincronía

En Javascript tenemos que trabajar a menudo con la asincronía, por ejemplo cuando trabajamos con llamadas AJAX. Muchas veces, puede resultar engorroso, debido a que en ocasiones debemos anidar las funciones de callback unas tras otras, cuando queremos realizar ciertas funciones cuando un proceso asíncrono se haya completado, es decir, que sean dependientes.   

Para controlar de una forma óptima la asincronía y hacerlo de una forma más legible y sencilla existe el patrón promesa. Consiste en que una determinada función en la que se va a ejecutar código de forma asíncrona devuelva lo que se llama una promesa. Esto es una especie de contrato, en el que se asegura que cuando se vaya a resolver la ejecución asíncrona, se le va a notificar a quien haya ejecutado la función. Aunque muchas librerías soportan promesas, hay una en concreto Q.js que cumple perfectamente la especificación del patrón promesa según la CommonJS ( [http://wiki.commonjs.org/wiki/Promises](http://wiki.commonjs.org/wiki/Promises)). Vamos a ver un ejemplo de cómo se trabaja con promesas, partiendo de la base que utilizamos Q:   

```javascript
var miPromesa = function () {   
  var d = Q.defer(); //inicializamos la promesa   
  //Aquí realizarías la petición asíncrona   
  funcionAsincrona({   
    onSuccess : function (datos) {   
      d.resolve(datos); //indicamos que se ha resuelto satisfactoriamente   
      // y mandamos los datos resultantes   
    },   
    onFailure : function (datosError) {   
      d.reject(datosError); //indicamos que se ha resuelto con error   
      //y enviamos lo que se reciba, que podría   
      // ser el mensaje de error   
    }   
  });   
  return d.promise; //devolvemos la promesa   
}
```

Ese digamos que es un esquema básico. Las promesas proporcionan una serie de métodos para poder tratar de forma secuencial las respuestas. En concreto los métodos then() para ejecutarse cuando se ha procesado correctamente, fail() cuando falla y done() cuando ha terminado la cadena:   

```javascript
var treatResponse, onResponseFailed;   

treatResponse = function (datosDelCallback) {   
    //codigo para tratar la respuesta   
};   

onResponseFailed = function (error) {   
//tratamos el error   
};   

miPromesa().then(treatResponse).fail(onResponseFailed).done();
```

Y las promesas pueden devolver otras promesas, es decir, si la función treatResponse devolviese a su vez otra promesa debido a que realizase alguna llamada asíncrona, podríamos concatenarlas de la siguiente forma:   

```javascript
miPromesa().then(treatResponse).then(otroMetodo).fail(onResponseFailed).done();
```

EL método fail en este caso, encapsula el fail de ambas promesas.   

Como vemos, el resultado es un código bastante legible.   

Las promesas nos permiten así mismo controlar cuando varios procesos asíncronos han terminado para hacer algo en ese momento. Esto normalmente se ha controlado con contadores, pero con las promesas es tan sencillo como utilizar el método all:   

```javascript
var miPromesa1, miPromesa2;   

miPromesa1 = function () {   
  var d = Q.defer(); //inicializamos la promesa   
  //Aquí realizarías la petición asíncrona   
  funcionAsincrona({   
    onSuccess : function (datos) {   
      d.resolve(datos); //indicamos que se ha resuelto satisfactoriamente   
      // y mandamos los datos resultantes   
    },   
    onFailure : function (datosError) {   
      d.reject(datosError); //indicamos que se ha resuelto con error   
      //y enviamos lo que se reciba, que podría   
      // ser el mensaje de error   
    }   
  });   
  return d.promise; //devolvemos la promesa   
};   

miPromesa2 = function () {   
  var d = Q.defer(); //inicializamos la promesa   
  //Aquí realizarías la petición asíncrona   
  funcionAsincrona({   
    onSuccess : function (datos) {   
      d.resolve(datos); //indicamos que se ha resuelto satisfactoriamente   
      // y mandamos los datos resultantes   
    },   
    onFailure : function (datosError) {   
      d.reject(datosError); //indicamos que se ha resuelto con error   
      //y enviamos lo que se reciba, que podría   
      // ser el mensaje de error   
    }   
  });   
  return d.promise; //devolvemos la promesa   
}   
```

Como vemos, son dos llamadas asíncronas. Si quisiéramos mostrar un alert con el string “completado”, bastaría con utilizar el método all(), que recibe un array de promesas:   

```javascript
var onAllCompleted = function () {   
  alert(“completado”);   
}   

Q.all([miPromesa1, miPromesa2]).then(onAllCompleted);
```

## 5.7\. Conclusión

Cuando desarrollemos Javascript hay que atender a las peculiaridades del lenguaje, para tener un código más óptimo y evitar problemas, así como hacer un desarrollo orientado a eventos apoyándonos en características de programación funcional y en patrones como las promesas. De esta forma conseguiremos tener menos problemas en nuestros desarrollos, así como un código mucho más legible, modularizado y fácil de mantener.   

Hay muchos más patrones que  pueden ayudarnos en nuestros desarrollos con Javascript. Un libro altamente recomendable es el “Learning javascript design patterns” escrito por Addy Osmani, al que se peude acceder de forma libre en el sitio [http://addyosmani.com/resources/essentialjsdesignpatterns/book/](http://addyosmani.com/resources/essentialjsdesignpatterns/book/)   

Recomendamos también seguir la guía de estilo JS de AirBnB

[Guía de estilo JS de airbnb](https://github.com/airbnb/javascript)

# 6\. Elección del framework

Hoy en día, existen numerosos frameworks cuyo objetivo es facilitar y aportar una metodología de desarrollo orientada exclusivamente al front. De entre todos los que están disponibles, en BEEVA apostamos por los siguientes:   

*   AngularJS
*   BackboneJS
*   ExtJS

La apuesta por estos tres frameworks se basa en su extendida utilización, lo que conlleva a una gran comunidad, el soporte y que con ellos conseguimos abarcar los distintos tipos de aplicación web más comunes y permiten implementar los distintos patrones de diseño más utilizados, que son el MVC (Modelo Vista Controlador), MVP (Modelo Vista Presentación) y MVVM (Modelo Vista Vista-Modelo). Pero, ¿cuándo utilizar cada patrón?. Dependiendo de las necesidades, normalmente utilizaremos el MVVM cuando tengamos componentes de vista que queramos reutilizar en distintos módulos, sin tener que escribir un comportamiento distinto en el gestor de cada módulo y también cuando queramos hacer uso de doble data-binding ya que se trata de un patrón orientado a conseguir este comportamiento. Para el resto de casos, podemos utilizar tanto el MVC como el MVP. De igual manera, en una aplicación web pueden coexistir varios patrones (por ejemplo un MVC con un MVVM), dependiendo de lo que se quiera conseguir, por lo que cada aplicación requerirá de un estudio previo para definir un patrón u otro, o el uso de varios. Es recomendable echar un vistazo a las especificaciones de cada patrón para entender mejor su funcionamiento, lo que se puede hacer a través del siguiente enlace:   

[http://nirajrules.wordpress.com/2009/07/18/mvc-vs-mvp-vs-mvvm/](http://nirajrules.wordpress.com/2009/07/18/mvc-vs-mvp-vs-mvvm/)   

Hoy en día, podemos distinguir entre 2 tipos de aplicaciones web, según su diseño e interacción. Estas son los Portales Web y las Aplicaciones Web RIA.   

## 6.1\. Portales Web

Son las aplicaciones web más clásicas y comunes. Son los típicos portales que aparecen comúnmente por internet: Webs de periódicos digitales, portales bancarios, etc. Hoy en día, suelen y deben tener un diseño Responsive o adaptativo, es decir, deben visualizarse de forma distinta dependiendo del dispositivo de visualización y no suelen tener un carácter general líquido, por lo que generalmente el contenedor se adapta al contenido (podemos observar que cuanto más crece el contenido de la página, aparece un scroll para poder visualizar el contenido en el marco general de la página). Otra característica es que cuando seleccionamos distintas opciones, cambia el contenido completo de la página, siendo una SPA (Single Page Application) o una aplicación web multipágina. Son el tipo de aplicaciones web que dominan en las extranets, ya que suelen ser más ligeras a la  hora de cargar, conteniendo menos cantidad de componentes web ricos y menos cantidad de código Javascript.  Para este tipo de aplicaciones, apostamos por los frameworks BackboneJS (en cuyo ecosistema incluimos requireJS, jQuery y UnderscoreJS como librerías auxiliares ) y AngularJS. Se trata de dos frameworks ligeros, a los que podemos ir añadiendo dependencias según necesidades (librerías de charting, distintos widgets, etc.). Los patrones de diseño que nos aportan son :   

*   BackboneJS: MVC y MVP
*   AngularJS: MVC y MVVM

Lo normal en Backbone, es utilizar un patrón MVC, ya que es el más utilizado y más familiar, por lo que es el patrón más adecuado. En cambio, en AngularJS es muy común encontrarse con implementaciones basadas en MVVM, aunque puede igualmente utilizarse el MVC.   

## 6.2\. Aplicaciones RIA

Se caracterizan por tener una gran cantidad de componentes “ricos”: árboles, grids de datos, pestañas, ventanas emergentes y otros muchos componentes complejos. En este tipo de aplicaciones no prima tanto que sea Responsive, sino más bien que sean líquidas. En estas aplicaciones es el contenido el que se adapta al contenedor. Son una simulación en web de las típicas aplicaciones de escritorio que se podían hacer con Java Swing, Visual Basic, etc. ¿Que serían aplicaciones de escritorio? por ejemplo un IDE de desarrollo, el FileZilla… Muchos ejemplos. En la actualidad, muchas aplicaciones web se pueden desarrollar utilizando estos formatos de diseño. Un ejemplo de aplicación de escritorio web la podemos ver aquí: [http://dev.sencha.com/extjs/5.0.0/examples/desktop/index.html](http://dev.sencha.com/extjs/5.0.0/examples/desktop/index.html). Existe una diferencia importante con respecto a los portales web, más tradicionales. Sí que es cierto que se trata de aplicaciones web pesadas, por lo que se suelen implementar para correr en intranets para aplicaciones de gestión por ejemplo. Para este tipo de aplicaciones web se recomienda el uso, en la medida de lo posible, del Framework ExtJS, ya que viene equipado con toda clase de widgets reutilizables y fácilmente extensibles y de todo tipo de librerías para no necesitar de otras externas (aunque bien pueden utilizarse dado el caso). En la versión actual, se puede realizar un desarrollo utilizando tanto el patrón MVVM como MVC.

## 7\. Referencias
  * [Guía de estilo JS de BEEVA](../javascript/)
  * [Guía de estilo JS de airbnb](https://github.com/airbnb/javascript)

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
