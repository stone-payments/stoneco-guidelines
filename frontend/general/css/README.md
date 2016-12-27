![alt text](../../../static/horizontal-beeva-logo.png "BEEVA")

# Front-end Development Best Practices

## CSS 
* Selectors and types of CSS classes
 * Rule declaration
 * ID selectors
* Formating
* Structure
 * OOCSS and BEM
* Other considerations
 * Important and Style
 * Based on CSS JavaScript functionality
 * Styles sheets Browsers
* Using CSS preprocessors
 * SASS
  * Syntax
  * Ordering of property declarations
  * Mixins
  * Placeholders
  * Nested selectors
 * Organize CSS
 
 
### Selectors and types of CSS classes

#### Rule declaration

We refer to a declaration Rule understood when we speak of a **selector** and a number of **properties** associated with this block.

```css
selector {
 property1: value1;
 property2: value2;
}
```

A **selector** is the way we identify any elements within the HTML document , you can refer to both a class attribute to any HTML element .
```css
.my-class { 
 // selector by className 
}

input { 
 // selector by HTML tag 
}

[name="myname"] {
 // selector by an attribute
}
```

The **properties** are the style rules to be applied by the selector element sectioned.
```css
/* selector */ {
 background: red;
 font-size: 12px;
}
```

#### ID selectors
While it is possible to select elements by ID in CSS, it should generally be considered an anti-pattern. ID selectors introduce an unnecessarily high level of [specificity](https://developer.mozilla.org/en-US/docs/Web/CSS/Specificity) to your rule declarations, and they are not reusable.

For more on this subject, read [CSS Wizardry's article](http://csswizardry.com/2014/07/hacks-for-dealing-with-specificity/) on dealing with specificity.

### Formating
* Use soft tabs (2 spaces) for indentation
* Prefer dashes over camelCasing in class names. Underscores are OK if you're using BEM (see [OOCSS and BEM](#oocss-and-bem) below).
* Do not use ID selectors
* When using multiple selectors in a rule declaration, give each selector its own line.
* Put a space before the opening brace `{` in rule declarations
* In properties, put a space after, but not before, the `:` character.
* Put closing braces `}` of rule declarations on a new line
* Put blank lines between rule declarations
* The use of comments should be double bars // to block comments, the comments at the end of line is avoided. 
* Comments book to detail not self-contained applications, such as using the z -index, or settings for browser compatibility.

**Bad**

```css
.avatar{
    border-radius:50%;
    border:2px solid white; }
.no, .nope, .not_good {
    // ...
}
#lol-no {
  // ...
}
```

**Good**

```css
.avatar {
  border-radius: 50%;
  border: 2px solid white;
}

.one,
.selector,
.per-line {
  // ...
}
```

### Structure

To write correctly CSS files are not enough rules described above is required to have certain clear concepts before starting to develop .
It should be clear that we can create the Laws of the Declaration with one or more of these guidelines:
* Structural
* Visual state
* Functional entity
* Functional status

In the style sheets not only the order in which the classes are defined, also depends on the accuracy of specifying a particular component. We must guide all styles of a **semantic** way so they are reusable as possible.

1. Structural

The structure css classes are those that reference **reusable components** in different applications or websites. Again become our reusable components. These must have a unique CSS class to make reference to them. For example, if we use two data grids on our website, we should never have a class grid-first and  another class grid-second, but both should have the same css class data- grid. If in any case requires the viewing is different, this is usually for functional reasons discussed below, in this case an overload of classes will be used, ie, applying a whole class to class data-grid to represent differences.
 
2. Visual state

The status display indicates which particular state of a component of any type ( structure or entity ). The most common states are:

  * Selected
  * Disabled
  * Focused
  * Actived
  * The hover property (eg buttons, links, row of a grid of data...)
  * Hidden
  * Editable

Other states like unchecked, enable hidden or not editable. We can consider that a component in its normal state possesses these characteristics.

Returning to the example of grids, if you have two grids that have to be differentiated and the difference could be the display status one another enabled and disabled. So, instead of having two classes css, one **grid-normal** and one **grid-disabled**, we could use a single class data- grid and use the state as a modifier :

```html
<table class=”data-grid”>   
  <tr>   
    <td><span>column 1<span></td>   
    <td>column 2</td>   
  </tr>   
</table>   
<table class=”data-grid disabled”>   
  <tr>   
    <td><span>column 1</span></td>   
    <td>column 2</td>   
  </tr>   
</table>   
```

And in our CSS, we would have the generic properties for data-grid and, in the modifier according to the state would be sufficient to override you need:

```css
table.data-grid {
  color: #000; width: 100%;
}   
table.data-grid.disabled {
  color: #CCC;
}   
```

And the same for the nodes that depend on it, as the span

```css
table.data-grid {
  color: #000; width: 100%;
}   
table.data-grid span {
  font-weight: bold;
}   

table.data-grid.disabled {
  color: #CCC;
}   
table.data-grid.disabled span {
  font-weight: normal;
}   
```

But also , you might want to not only depended on the status of view, but on different screens, we want to be displayed differently depending on the type of display, which has a functional nature, which we will try next.

3. Functional entity

These can be either to refer to certain entities (students, courses, teachers...) and more global entities, as it could be an administration module. In the following example we will see how we could differentiate the grids data management module from the rest of the application:

```html
<!-- Management Module -->   
<div class=”administration”>   
  <table class=”data-grid”>   
    <tr>   
      <td><span>column 1<span></td>   
      <td>column 2</td>   
    </tr>   
  </table>   
  <table class=”data-grid disabled”>   
    <tr>   
      <td><span>column 1</span></td>   
      <td>column 2</td>   
    </tr>   
  </table>   
</div>   

<!-- Another Module -->   
<div class=”administration”>   
  <table class=”data-grid”>   
    <tr>   
      <td><span>column 1<span></td>   
      <td>column 2</td>   
    </tr>   
  </table>   
  <table class=”data-grid disabled”>   
    <tr>   
      <td><span>column 1</span></td>   
      <td>column 2</td>   
    </tr>   
  </table>   
</div>   
```

Well, it suffices to make the rules depend hierarchically in terms of these entities:

```css
/* generic Grid */   

table.data-grid {
  color: #000; 
  width: 100%;
}   
table.data-grid span {
  font-weight: bold;
}   

table.data-grid.disabled {
  color: #CCC;
}   
table.data-grid.disabled span {
  font-weight: normal;
}   

/* Management Module */   

.administration table.data-grid {
  color: #fff;
  background: #000; 
}   
```

Simply we override it what interests us, keeping the rest of default rules for both spans containing as to the disabled state, also can be overridden if interesase.

For these classes are useful, they must be located in the upper HTML node, the father highest level overarching umbrella to rest, to not have to be repeated in the HTML. They must be included once. However, in CSS, any rule which depends on this class should reflect on the CSS rule. For instance:

```html
<div class=”user”>   
<form class=”form-user”>   
…   
</form>   
</div> 
```

```css
.user {
  font-size: 14;
}   
.form-user {
  padding: 5px;
}   
```

This would be wrong. If we want to indicate to form a class, it should not contain anything regarding user. Instead, it should be accessed through the class hierarchy:

```html
<div class=”user”>   
<form>   
…   
</form>   
</div> 
```

```css
.user {
  font-size: 14;
}   
.user form {
  padding: 5px;
}   
```

or, if we want to give a special class to the form so that this rule not all forms are applicable:

```html
<div class=”user”>   
<form class=”registration”>   
…   
</form>   
</div> 
```

```css
.user {
  font-size: 14;
}   
.user form {
  padding: 5px;
}   
.user form.registration {
  font-size: 11px;
}   
```

Thus, all forms of user dependent class would have a font size of 14px and a general padding of 5px, except the registration form, which will overwrite the font size.

4. Functional status

Finally, would the CSS classes of functional status, which refer to individual states may have a particular entity. For example, for different states can have the elements of a message (header, icon, date, etc) in a messaging system. We could have many different css classes for these elements, for example, in terms of icons: ico-sent, ico-received, ico-read... A simple and semantic form, would add that state as a modifier of the css class that represents functional entity, seen in the previous point, defining the normal rules of each camp. For example, let's focus on the field icon:

```html
<div class=”message received”>   
  <span class=”transmitter”>Jhon Doe</span>   
  <span class=”receiver”>Jane Doe</span>   
  <span class=”send-date”>12/12/2013</span>   
  <span class=”reception-date”>-</span>   
  <span class=”ico”>-</span>   
</div>   
```

```css
/*First we define the general characteristics for icons of messages. A note: use sprites for images to reduce calls to the server*/   

.message span.ico {   
  display: inline-block;   
  width: 20px;   
  height: 100%;   
  background-image: url(‘sprite_path’);   
}   

/*Now we define the positions of images by state message*/   

.message.sent span.ico {
  background-position: 0 0
}   
.message.received span.ico {
  background-position: 0 20px
}   
.message.read span.ico {
  background-position: 0 40px
}   
```

Thus, we must not create lots of css classes, creating quite optimized, reusable and easy to maintain files.

All previous considerations apply using certain forms of work are OOCSS and BEM .

#### OOCSS and BEM

To optimize the use of CSS to use some working guidelines such as those in OOCSS and BEM is proposed. The proposed improvements are:
  * It helps create clear, strict relationships between CSS and HTML
  * It helps us create reusable, composable components
  * It allows for less nesting and lower specificity
  * It helps in building scalable stylesheets
  
**OOCSS**, or “Object Oriented CSS”, proposes the creation of reusable and independent blocks.
  * Nicole Sullivan's [OOCSS wiki](https://github.com/stubbornella/oocss/wiki)
  * Smashing Magazine's [Introduction to OOCSS](http://www.smashingmagazine.com/2011/12/12/an-introduction-to-object-oriented-css-oocss/)

**BEM**, or “Block-Element-Modifier”, it is a naming convention for CSS classes by establishing a set of guidelines.
  * CSS Trick's [BEM 101](https://css-tricks.com/bem-101/)
  * Harry Roberts' [introduction to BEM](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/)

```html
<article class="listing-card listing-card--featured">

  <h1 class="listing-card__title">Adorable 2BR in the sunny Mission</h1>

  <div class="listing-card__content">
    <p>Vestibulum id ligula porta felis euismod semper.</p>
  </div>

</article>
```

```css
.listing-card { }
.listing-card--featured { }
.listing-card__title { }
.listing-card__content { }
```

  * `.listing-card` is the “block” and represents the higher-level component
  * `.listing-card__title` is an “element” and represents a descendant of `.listing-card` that helps compose the block as a whole.
  * `.listing-card--featured` is a “modifier” and represents a different state or variation on the `.listing-card` block.


### Other considerations

Here are some notes that do not fall in the other sections even if it may have been mentioned previously discussed above.

#### Important and Style

In addition to the rules seen above, must be avoided as far as possible use the switch **!important** and / or **style** property of DOM nodes.

As for the style property, it is often essential to use. For example, it is imperative for many when frameworks provide dynamic attributes such as width, height, etc. to offer a dynamic and / or flexible components. However, what it is to be avoided at this property indicate attributes of constant styles. Anything must be consistent in its corresponding CSS file.
And, for the switch **!important**, there are times in which it is essential. For example, in those cases in which frameworks accessing the style property and modify a particular attribute, for any reason, we want to be consistent and we have defined in our CSS. As inclusion in the style property overrides the classes defined in the CSS as a general rule, we can only do so using this switch, overriding the value in our style sheet, but should be limited use as far as possible.

#### Based on CSS JavaScript functionality

In order to separate the structure and functionality display an entirely. When applied to an element functionality through the use of CSS classes to use for this specific classes that must begin with an identification code, eg js-my-class is recommended.

```html
<div class="container">
  <p>This is the reference to a <span class="link js-link-click">link</span></p>
</div>
```

Wrong way:
```javascript
$('.link').click(function(){alert('Please use a js-link-click class')});
```

Right way:
```javascript
$('.js-link-click').click(function(){alert('this is the right way')});
```

#### Styles sheets Browsers

Another measure that may be useful, to avoid having to include specific styles sheets for each browser, Javascript is added using a CSS class BODY DOM node, referring to the browser. For instance:

For IE7   

```html
<html>   
<head>   
...   
</head>   
<body class=”ie v7”>   
</body>   
</html>   

For Chrome   
<html>   
<head>   
...   
</head>   
<body class=”chrome”>   
</body>   
</html>   
```

Thus, we can have generic classes that are cross-browser and overwrite only what is necessary depending on the browser.

```css
/*Generic*/   
.data-grid {padding: 4px;}   

/*For IE7*/   
.ie.v7 .data-grid {padding: 2px;}
```

### Using CSS preprocessors

Preprocessors are tools that provide meta for creating CSS files. These are translated into CSS files that will be inserted into the Web.

There are different preprocessors in the market among them Sass/Compass and Less are the most widespread. These tools allow you to create variables and functions for use in CSS, as well as providing features such as loops. optimizing the generation, readability and reuse of CSS.

However, the recommendation is to use SASS/Compass, to the greatest extent in the community.

For correct use of these tools it is necessary to have knowledge of good practice in creating CSS, in order to exploit the power of these preprocessors.   

#### SASS

##### Syntax

* Use the `.scss` syntax, never the original `.sass` syntax
* Order your `@extend`, regular CSS and `@include` declarations logically (see below)

##### Ordering of property declarations

1. `@extend` declarations

    Just as in other OOP languages, it's helpful to know right away that this “class” inherits from another.

    ```scss
    .btn-green {
      @extend %btn;
      // ...
    }
    ```

2. Property declarations

    Now list all standard property declarations, anything that isn't an `@extend`, `@include`, or a nested selector.

    ```scss
    .btn-green {
      @extend %btn;
      background: green;
      font-weight: bold;
      // ...
    }
    ```

3. `@include` declarations

    Grouping `@include`s at the end makes it easier to read the entire selector, and it also visually separates them from `@extend`s.

    ```scss
    .btn-green {
      @extend %btn;
      background: green;
      font-weight: bold;
      @include transition(background 0.5s ease);
      // ...
    }
    ```

4. Nested selectors

    Nested selectors, _if necessary_, go last, and nothing goes after them. Add whitespace between your rule declarations and nested selectors, as well as between adjacent nested selectors. Apply the same guidelines as above to your nested selectors.

    ```scss
    .btn {
      @extend %btn;
      background: green;
      font-weight: bold;
      @include transition(background 0.5s ease);

      .icon {
        margin-right: 10px;
      }
    }
    ```

##### Mixins

Mixins, defined via `@mixin` and called with `@include`, should be used sparingly and only when function arguments are necessary. A mixin without function arguments (i.e. `@mixin hide { display: none; }`) is better accomplished using a placeholder selector (see below) in order to prevent code duplication.

##### Placeholders

Placeholders in Sass, defined via `%selector` and used with `@extend`, are a way of defining rule declarations that aren't automatically output in your compiled stylesheet. Instead, other selectors “inherit” from the placeholder, and the relevant selectors are copied to the point in the stylesheet where the placeholder is defined. This is best illustrated with the example below.

Placeholders are powerful but easy to abuse, especially when combined with nested selectors. **As a rule of thumb, avoid creating placeholders with nested rule declarations, or calling `@extend` inside nested selectors.** Placeholders are great for simple inheritance, but can easily result in the accidental creation of additional selectors without paying close attention to how and where they are used.

**Sass**

```sass
// Unless we call `@extend %icon` these properties won't be compiled!
%icon {
  font-family: "Airglyphs";
}

.icon-error {
  @extend %icon;
  color: red;
}

.icon-success {
  @extend %icon;
  color: green;
}
```

**CSS**

```css
.icon-error,
.icon-success {
  font-family: "Airglyphs";
}

.icon-error {
  color: red;
}

.icon-success {
  color: green;
}
```

##### Nested selectors

**Do not nest selectors more than three levels deep!**

```scss
.page-container {
  .content {
    .profile {
      // STOP!
    }
  }
}
```

When selectors become this long, you're likely writing CSS that is:

* Strongly coupled to the HTML (fragile) *—OR—*
* Overly specific (powerful) *—OR—*
* Not reusable


Again: **never nest ID selectors!**

If you must use an ID selector in the first place (and you should really try not to), they should never be nested. If you find yourself doing this, you need to revisit your markup, or figure out why such strong specificity is needed. If you are writing well formed HTML and CSS, you should **never** need to do this.

#### Organize CSS

In the development should generate multiple CSS that will later be unified for production environments. With that we improve the encapsulation of the different needs of the project. 

Using CSS preprocessors is recommended to have an initial file that loads the rest , thus the order in which the classes defined in each of the files are loaded is controlled.

```css
/*** main.scss content */
/* general */
@import colors.scss;
@import fonts.scss;
@import containers.scss;
@import buttons.scss;
...

/* specific */
@import students.scss;
...
```

To make this separation are certain criteria:

* Generic reusable components
* Functional application components

Reusable components are those that are not part of the application itself that we are developing, it can be used in various applications. These are for example the css for data grids, select boxes, trees and other reusable components or widgets. These components may come from third-party libraries or frameworks that overwrite, but if they themselves want to reuse components between applications we have to pay special attention to this separation because it will allow us to preserve independecia to be reused in the current project or another.

Other components are functional, that is, focusing on all visual content having a certain functionality. They can be several pages of a traditional website based on a pattern of multiple pages, the various functional modules or applications that follow a pattern of a single page or SPA (Single Page Application ). For example, a course management application, we could have a module students with all the CSS that was related to this module located in a students.css file.

These two approaches are not mutually exclusive. It is useful to identify elements that are general and create a reuse approach, and certainly appear specifications related to functionality, which will overload these general styles.

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
