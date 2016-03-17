# Debates in the Digital Humanities

## General Dev practices

Before installing gems with Bundler verify you are running Java 6.  If you run `java -version` you should see 
```
java version "1.6.0_65"
Java(TM) SE Runtime Environment (build 1.6.0_65-b14-468-11M4833)
Java HotSpot(TM) 64-Bit Server VM (build 20.65-b04-468, mixed mode)
```

Java 6 legacy can be [download for OSX Capitan here] (https://support.apple.com/kb/dl1572?locale=en_US).  After installing Java 6, `bundle install` as normal.

Seed data with `rake db:seed` and then parse the sample texts using `rake texts:import`

Run the rails server using shell script: `script/server`
May access rails cli using '`script/rails`