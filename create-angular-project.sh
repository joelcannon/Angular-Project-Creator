#!/bin/bash

# Check if project name is supplied
if [ -z "$1" ]
then
  echo "Error: No project name provided."
  exit 1
fi

# Check if project directory already exists
if [ -d "$1" ]
then
  echo "Error: Directory $1 already exists."
  exit 1
fi

# Create a new Angular project
ng new $1 --prefix=$1 --no-strict --standalone false --routing false --package-manager=pnpm || { echo "Error: Failed to create Angular project."; exit 1; }

# Navigate into the project directory
cd $1 || { echo "Error: Failed to navigate to project directory."; exit 1; }

# Install the necessary packages
pnpm add -D eslint@8.56.0 prettier eslint-config-airbnb-typescript eslint-plugin-prettier eslint-config-prettier eslint-plugin-import@^2.25.2 @angular-eslint/eslint-plugin@^17.3.0 @angular-eslint/eslint-plugin-template@^17.3.0 @angular-eslint/template-parser@^17.3.0 @typescript-eslint/parser || { echo "Error: Failed to install ESLint, Prettier, Airbnb config, Angular ESLint plugins, and TypeScript ESLint parser."; exit 1; }

# Install @typescript-eslint/parser separately
pnpm add -D @typescript-eslint/parser || { echo "Error: Failed to install @typescript-eslint/parser."; exit 1; }

# Create .eslintrc.json
echo '{
  "extends": ["plugin:@angular-eslint/recommended", "plugin:prettier/recommended"],
  "parserOptions": {
    "project": "./tsconfig.json"
  },
  "rules": {
    "prettier/prettier": ["error"]
  }
}' > .eslintrc.json

# Create .prettierrc
echo '{
  "singleQuote": true,
  "trailingComma": "es5"
}' > .prettierrc

# Create a .npmrc file to enforce the use of pnpm
echo 'engine-strict=true' > .npmrc || { echo "Error: Failed to create .npmrc."; exit 1; }

# Add pnpm to the "engines" field of package.json using PowerShell
powershell -Command "(Get-Content package.json) -replace '\"dependencies\"', '\"engines\": { \"pnpm\": \"^8.15.6\" }, \"dependencies\"' | Set-Content package.json" || { echo "Error: Failed to update package.json."; exit 1; }

# Install Bootstrap 3 and jQuery
pnpm install bootstrap@3 jquery || { echo "Error: Failed to install Bootstrap 3 and jQuery."; exit 1; }


# Add lint script to package.json
jq '.scripts.lint = "eslint --fix \"./src/**/*.ts\""' package.json > temp.json && mv temp.json package.json || { echo "Error: Failed to add lint script."; exit 1; }

# Modify angular.json to include styles and scripts
jq '.projects["'$1'"].architect.build.options |= .+ {"styles": ["node_modules/bootstrap/dist/css/bootstrap.min.css", "src/styles.css"], "scripts": ["node_modules/jquery/dist/jquery.min.js", "node_modules/bootstrap/dist/js/bootstrap.min.js"]}' angular.json > temp.json && mv temp.json angular.json || { echo "Error: Failed to modify angular.json."; exit 1; }