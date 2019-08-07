```
project
 |- mytool.sh.env
 |- mytool.sh
 |- main.sh
 |- lib
 |   \- mytool
 |       \- mylib.sh
 |- dep
 |   \- foo
 |       \- foolib.sh
 \- target
     |- bin
     |   |- mytool.sh
     |   |- main.sh
     |   |- lib
     |   |   |- mytool/mytool.sh
     |   |   \- foo/foolib.sh
     \- mytool.zip
```

-- mytool.env --
```
BASHIR_MAIN_FILE=lib/mymain.sh
```

`bashirImport`
```
  if -f lib/$path then ...
  elif -f dep/$path then ...
  else fail
```

`bashir init`
```
  copy the bashir.sh script to a target entrypoint script (prompt for name or --name=<name>)
  create the main.sh script and the lib/<name> directory
  create .gitignore file (to ignore the target directory)
```

`bashir clean`
```
  delete the target directory
```

`bashir package`
```
  create the target directory
  copy all scripts from the lib and dep directories to target/bin/lib
  copy the <name>.sh and main.sh scripts, and the <name>.sh.env file to target/bin
  create a <name>.zip of all the content of target/bin
```

Other:
```
bashir test
bashir lint
bashir dep-ensure
```