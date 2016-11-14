(Imagen principal)

# Cucumber
Test, automation and alive documentation with Cucumber

## Index

* [What is Cucumber?](#what-is-cucumber)
* [ATDD & BDD with Cucumber](#atdd-&-bdd-with-cucumber)
* [Alive Documentation](#alive-documentation)
* [Life cycle](#life-cycle)
* [Cucumber implementations](#cucumber-implementations)

### What is Cucumber?

Cucumber is a development tool for the automatic execution of the application acceptance test. It allow the business analyst to describe in a natural way the acceptance criteria of the application using Gherkin for it. On the same way it give the developers the possibility of execute that criteria like test against the application. That feature makes Cucumber really useful on agile development methodologies like [ATDD](./testing/ATDD/README.md) y [BDD](./testing/GoodPractivesBDD.md)

### ATDD & BDD with Cucumber

Without details, ATDD is an agile development methodology guided by acceptance test. ATDD also includes BDD, which is an agile development methodology guided by the behavior of the application. It means that, the same acceptance criteria can includes different behavior criteria of the application.

One of the biggest difference between ATDD and BDD is the detail level on the criteria description. Thus Cucumber can be applied on both methodologies. Cucumber allow the execution of criteria or behavior of the application described by business analyst like a test. That is why all depends on the detail level which the different criteria would be described. If both methodologies are used, it could be possible to have a few high level acceptance test that shows the use of ATDD on the project and, on the other hand, a greater number of more detailed behavior test following BDD methodology.

That is why Cucumber can be used with both methodologies, making easier the agile development on both of them.

### Alive documentation

Uno de los mayores problemas que suelen tener los proyectos informáticos es el mantenimiento de su propia documentación y más ahora que los proyectos son cada vez más ágiles y dinámicos. Al utilizar metodologías ágiles de desarrollo como las ya comentadas, los cambios sobre la aplicación son constantes, pudiendo dejar la documentación desactualizada en cuestión de semanas. Esto conlleva unos altos costes de mantenimiento de dicha documentación si queremos tenerla siempre al día.

Aquí es donde Cucumber permite que dicha documentación se mantenga siempre actualizada. Usando Cucumber junto a Gherkin para describir los criterios de aceptación y de comportamiento de la aplicación, permitirá que dicha documentación no pueda quedarse desactualizada. Por el hecho de que es la documentación misma la que se usa para probar el comportamiento de la aplicación.

### Life cycle

El ciclo de vida ideal de los test con cucumber es el siguiente:

* 1. Escritura de escenarios con Gherkin

El primer paso consiste en escribir los escenarios con Gherkin. Cada escenario debe describir una funcionalidad concreta manteniendo un nivel de abstracción adecuado, es decir, dependiendo de si son test de aceptación o test de comportamiento, deberán encontrarse en equilibrio entre la visión de negocio y la visión puramente técnica. Por ello los escenarios deberían ser escritos de forma conjunta por una persona de negocio, un desarrollador y un tester de la aplicación.

Un ejemplo de escenario escrito con Gherkin es el siguiente:

> * Feature: Hello Cucumber
> * As a product manager
> * I want our users to be greeted when they visit our site
> * So that they have a better experience
> *
> * Scenario: User sees the welcome message
> * When I go to the homepage
> * Then I should see the welcome message

* 2. Implementación de los escenarios

Una vez los escenarios se encuentran correctamente descritos y se ha llegado a un acuerdo entre la gente de negocio y los desarrolladores, es el momento de implementar dichos escenarios. Usando Cucumber, se puede dar funcionalidad a todos y cada uno de los pasos descritos con Gherkin, de tal forma que cada paso interactúe con la aplicación, consiguiendo pruebas ejecutables sobre la aplicación.

Y un ejemplo de implementación de un escenario en Ruby es el siguiente:

> * When(/^I go to the homepage$/) do
> *   visit root_path
> * end

* 3. Implementación de la funcionalidad en la aplicación

El siguiente paso lógico es la implementación de la funcionalidad dentro de la aplicación, la cual deberá cumplir con lo descrito en el escenario. Para asegurarnos de que cumple con lo descrito, la nueva funcionalidad deberá pasar los test descritos por los escenarios.

* 4. Automatización de los escenarios

Y por último, según se vayan creando funcionalidades, se irán creando escenarios ejecutables de pruebas sobre la aplicación. Y automatizando la ejecución de dichos escenarios nos aseguraremos de que todas las pruebas especificadas se ejecuten para todas aquellas nuevas funcionalidades que se deseen integrar. Esto nos ayudará a mantener el correcto funcionamiento de la aplicación y a saber en todo momento si nuestras nuevas funcionalidades rompen o no la aplicación.

De esta forma, conseguiremos una documentación viva que se mantiene actualizada junto a la aplicación, que varía con ella y que además permite asegurar que la aplicación se sigue comportando de la forma deseada.

### Cucumber implementation

* On main Cucumber implementation with Ruby, the standard directory structure is:

> * features - Contains feature files, which all have a .feature extension. May contain subdirectories to organize feature files.

> * features/step_definitions - Contains step definition files, which are Ruby code and have a .rb extension.

> * features/support - Contains supporting Ruby code. Files in support load before those in step_definitions, which makes it useful for such things as environment configuration (commonly done in a file called env.rb).

All the main Cucumber implementations can be found on it's [main page](https://cucumber.io/docs#reference)
