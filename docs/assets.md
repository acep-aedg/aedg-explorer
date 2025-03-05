# Asset handling for rails applications

The AEDG-Explorer is configured to use importmaps for bundling javascript and yarn for CSS dependencies. 

## Adding javascript assets

`importmap` is will only handle javascript libraries and not CSS. This means that if you install a javascript library that includes CSS you will also need to include it using `yarn add LIBRARY` steps below.

## Adding CSS assets

To install CSS dependencies you'll use the normal `yarn add LIBRARY`. Then to include the css/scss files you will need to add `import` commands into the `application.bootstrap.css` file. 
