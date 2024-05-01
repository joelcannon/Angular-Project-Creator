I wrote a shell script that takes a project name and then configures an Angular project with a prefix and all my preferences, which include eslint, prettier, and the Airbnb styles guide for Angular using pnpm (instead of npm).
The main benefit is that you can run the lint script and it fixes all the project files to follow the new rules and then formats all new files on save.  It does a great job of identifying early problems and makes the autocomplete super smart (feels like it is reading my mind).

Download it to the parent directory where you want to create a new project ( I have them all in a directory called wdd430)
and then make it executable with this command.

  chmod +x create-angular-project.sh

and run it using bash
  ./create-angular-project.sh TheNameOfYouNewProject
