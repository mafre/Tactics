function Users()
{
	User = require('./user.js');
	MessageTypes = require('../message/messageTypes.js');

	var mongoose = require('mongoose');

    global.debug = false;
	global.delay = 1000;

	var self = this;
	self.users = [];
    self.messageTypes = new MessageTypes();

	var userSchema = mongoose.Schema
	({
		email : String,
		avatarId: Number
	});

	userSchema.methods.log = function()
	{
		var greeting = this.userName
		? "My name is " + this.userName
		: "I don't have a name"
		console.log(greeting);
	};

	userSchema.plugin(require('basic-auth-mongoose'));

	var UserModel = mongoose.model('User', userSchema);

	self.addUser = function(socket)
	{
		var user = new User(socket);
		var data = {};
		data["id"] = socket.id;
		user.sendMessage(self.messageTypes.messageSetUserId, data);
		self.users.push(user);
	};

	self.removeUser= function(aId)
	{
		var userIndex = -1;

		for(var i = 0; i < self.users.length; i++)
		{
			if(self.users[i].id == aId)
			{
				userIndex = i;
				break;
			};
		};

		if(userIndex == -1)
		{
			return;
		};

		for (var i = 0; i < self.users.length; i++)
		{
			var data = {};
  			data["id"] = aId;
  			self.users[i].sendMessage(self.messageTypes.messageRemoveUser, data);
		};

		self.users.splice(userIndex, 1);
	};

    self.initUser = function(aUser, aPassword)
    {
        var user = self.findUserByEmail(aUser.email, function(foundUser)
        {
            if(!foundUser)
            {
                self.saveUser(aUser, aPassword);
            }
        });
    };

    self.saveUser = function(aUser, aPassword)
    {
        console.log("-- save user");
        console.log(aUser.email + " " + aUser.avatarId + " " + aUser.userName + " " + aPassword);

        var user = new UserModel({ email: aUser.email, avatarId: aUser.avatarId, username: aUser.userName, password: aPassword });

        user.save(function (err, user)
        {
            if (err) return console.error(err);
            user.log();
        });
    };

	self.findUserByName = function(aName, aCallback)
	{
		UserModel.find({ userName: aName }, function (err, users)
		{
			if(err)
			{
				console.error("error " + err);
			}
			else
			{
				if(users.length > 0)
				{
					aCallback(users[0]);
				}
				else
				{
					aCallback();
				};
			};
		});
	};

	self.findUserByEmail = function(aEmail, aCallback)
	{
		UserModel.find({ email: aEmail }, function (err, users)
		{
			if(err)
			{
				console.error("error " + err);
			}
			else
			{
				if(users.length > 0)
				{
					aCallback(users[0]);
				}
				else
				{
					aCallback();
				};
			};
		});
	};

	self.getUserById = function(aId)
	{
		for (var i = 0; i < self.users.length; i++)
  		{
  			if(self.users[i].id == aId)
  			{
  				return self.users[i];
  			};
  		};
	};

	self.getUserByName = function(aName)
	{
		for (var i = 0; i < self.users.length; i++)
  		{
  			if(self.user[i].userName == aName)
  			{
  				return self.users[i];
  			};
  		};
	};

	self.getUserIndex = function(aId)
	{
		for (var i = 0; i < self.users.length; i++)
  		{
  			if(self.users[i].id == aId)
  			{
  				return i;
  			};
  		};
	};




    // --- From client ---

    self.login = function(aId, aEmail, aPassword)
    {
        var aUser = self.getUserById(aId);

        if(!aUser)
        {
            return;
        };

        self.findUserByEmail(aEmail, function(foundUser)
        {
            if(foundUser)
            {
                if(foundUser.authenticate(aPassword))
                {
                    aUser.username = foundUser.username;
                    aUser.email = foundUser.email;
                    aUser.avatarId = foundUser.avatarId;

                    var data = {};
                    data["id"] = aId;
                    data["userName"] = aUser.userName;
                    data["avatarId"] = aUser.avatarId;

                    aUser.sendMessage(self.messageTypes.messageLoggedIn, data);
                }
                else
                {
                    aUser.sendMessage(self.messageTypes.messageLoginWrongPassword);
                };
            }
            else
            {
                aUser.sendMessage(self.messageTypes.messageLoginUserNotFound);
            };
        });
    }

    self.createUser = function(aId, aName, aEmail, aAvatarId, aPassword)
    {
        var aUser = self.getUserById(aId);

        if(aUser)
        {
            aUser.userName = aName;
            aUser.avatarId = aAvatarId;
            aUser.email = aEmail;

            self.findUserByEmail(aEmail, function(foundUser)
            {
                if(foundUser)
                {
                    aUser.sendMessage(self.messageTypes.messageCreateEmailTaken);
                }
                else
                {
                    self.initUser(aUser, aPassword);

                    var data = {};
                    data["id"] = aId;
                    data["userName"] = aUser.userName;
                    data["avatarId"] = aUser.avatarId;

                    aUser.sendMessage(self.messageTypes.messageUserCreated, data);
                };
            });
        };
    };
};

module.exports = Users;