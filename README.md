# HipChat_Perl
HipChat Utility for Perl.  Allows you to quickly hack out a HipChat bot

# Installation
I'm using submodules, so the easiest way to get the whole project is:
```
git clone --recursive git@github.com:aarontharris/HipChat_Perl.git
```

After that, you'll need to copy or symlink the HipChat_Perl folder to your WebServer's cgi-bin (or where ever you have it configured).

For me, using tomcat7 on Ubuntu it's like so:
```
cd /var/lib/tomcat7/webapp/ROOT/WEB-INF/cgi
ln -s ~/github/HipChat_Perl hipchat
```

Now you need to create an integration point for your HipChat room.

- Sign into HipChat
- Goto: https://<YourHipChatServer>.hipchat.com/rooms
- Select the room you're playing with
- Click "Integrations"
- Click "Find New"
- Click Build Your Own => Create
- Name the Integration, this is the bot name that appears in the room (You can change the name later)
- Click "Create"
- Read everything carefully, then check the box at the bottom "Add a command"
- Enter your Slash-Command, like "/computer", "/R2D2", "/Dobby" (You can change the command later)
- "We will POST to this URL" make sure you get this right: "http://yourdomain.com/cgi-bin/hipchat/proxify_hipchat.cgi"
- Click "Save"
- Go to your room and type: ```/computer what time is it?``` and you should get a surprise.

# Code peepers
proxify_hipchat.cgi is your starting point.  It basically catches HipChat's postData and bundles it into some friendly OOPerl HipChatness and allows you to read what the user typed and respond appropriately.  For deeper peeping, the HipChat/HipChat.pm contains the HipChat classes, they're pretty basic but very convenient.  Even deeper is my own home brewed JsonParser which I have written for simpler Server deploys (you shouldn't need to install any non-standard Perl Modules), you can inspect JsonParser.pm under the ATH dir as well as my ATH.pm which is just some tool bits.

# What's missing and possibly coming soon
HipChat supports sending messages withing having to respond to a user /command.  For example, it might be fun to have some code that sends a message to the HipChat room every few minutes.  For now, this is not supported.  To accomplish this, you'll need to register some auth tokens and roomIds and have some form of persistence to remember it all.  It'll come but not today.

That's all for now, enjoy.

