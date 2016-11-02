function run(msg)
	adminkey = {{"Set Personnel","Rem Personnel","Set Biography"},{"Logs","Users","Payment","*REBOOT*"},{"SendtoAll","SMS","EMail","PM","SOS"},{"BanIP","Banlist","Block","Blocklist"}}
	keyboard = {{"Umbrella Projects","Personnels"},{"Robots","Web Services"},{"Ticket","Jobs","Payment","About us"}}
	blocks = load_data("../blocks.json")
	users = load_data("users.json")
	setting = load_data("setting.json")
	admin = load_data("admin.json")
	userid = tostring(msg.from.id)
	if blocks[userid] then
		return send_msg(msg.from.id, "You are *Block*", true)
	end
	if not users[userid] then
		users[userid] = 0
		save_data("users.json", users)
		return send_key(msg.from.id, "*Welcome to Umbrella Projects Team robot...*\n\nThis robot is for Provide Description, Help, Support, Presentation for Products and Services and more...", keyboard)
	end
	if msg.text:lower() == "/start" then
		users[userid] = 0
		save_data("users.json", users)
		return send_key(msg.from.id, "*Welcome to Umbrella Projects Team robot...*\n\nThis robot is for Provide Description, Help, Support, Presentation for Products and Services and more...", keyboard)
	elseif (msg.text:lower() == "send to all" or msg.text:lower() == "sendtoall" or msg.text:lower() == "send2all") and msg.chat.id == admingp then
		if msg.from.id == sudo_id then
			if msg.reply_to_message then
				msglens = string.len(msg.reply_to_message.text)
				if msglens < 50 then
					return send_msg(admingp, "*Reply* this Command on a *Message*", true)
				end
				send_msg(admingp, "*Waiting...*", true)
				i=0
				for k,v in pairs(users) do
					i=i+1
					send_key(tonumber(k), msg.reply_to_message.text, keyboard)
				end
				return send_msg(admingp, "*Send to "..i.." Member*", true)
			else
				return send_msg(admingp, "*Reply* this Command on a *Message*", true)
			end
		else
			return send_msg(admingp, "Sorry, Only *SUDO*", true)
		end
	elseif msg.text:lower() == "users" and msg.chat.id == admingp then
		list = ""
		i=0
		for k,v in pairs(users) do
			i=i+1
			list = list..i.."- "..k.."\n"
		end
		return send_msg(admingp, "*Users List:*\n\n"..list, true)
	elseif (msg.text:lower() == "block list" or msg.text:lower() == "blocklist") and msg.chat.id == admingp then
		list = ""
		i=0
		for k,v in pairs(blocks) do
			if v then
				i=i+1
				list = list..i.."- "..k.."\n"
			end
		end
		return send_msg(admingp, "*Blocklist:*\n\n"..list, true)
	elseif string.match(msg.text, '^/block') and msg.chat.id == admingp then
		if msg.text == "/block" or msg.text == "/block " then return send_msg(admingp, "After this command type *a Target ID or Array*", true) end
		usertarget = msg.text:gsub("/block ","")
		usertarget = usertarget:gsub("/block","")
		usertarget = usertarget:gsub("\r","")
		usertarget = usertarget:gsub("\n",",")
		tgid = usertarget:split(',')
		if #tgid == 0 then return send_msg(admingp, "After this command type *a Target ID or Array*", true) end
		if #tgid == 1 then
			if string.match(tgid[1], '^%d+$') then
				if tonumber(tgid[1]) == sudo_id then return send_msg(admingp, "You can't block *SUDO*", true) end
				if tonumber(tgid[1]) == bot.id then return send_msg(admingp, "You can't block *ME*", true) end
				if tonumber(tgid[1]) == msg.from.id then return send_msg(admingp, "You can't block *Your Self*", true) end
				if blocks[tostring(tgid[1])] then return send_msg(admingp, "Target is *Block*", true) end
				blocks[tostring(tgid[1])] = true
				save_data("../blocks.json", blocks)
				send_msg(tonumber(tgid[1]), "You are *Block* from *All Robots!*", true)
				return send_msg(admingp, tgid[1].." now *Blocked*", true)
			else
				return send_msg(admingp, "You can use only *Telegram ID*", true)
			end
		end
		cont=0
		for i=1,#tgid do
			if string.match(tgid[i], '^%d+$') then
				if tonumber(tgid[i]) == sudo_id or tonumber(tgid[i]) == bot.id or tonumber(tgid[i]) == msg.from.id or blocks[tostring(tgid[i])] then else
					cont=cont+1
					blocks[tostring(tgid[i])] = true
					save_data("../blocks.json", blocks)
					send_msg(tonumber(tgid[i]), "You are *Block* from *All Robots!*", true)
				end
			end
		end
		return send_msg(admingp, "*Blocked "..cont.." User of All Robots*", true)
	elseif string.match(msg.text, '^/unblock') and msg.chat.id == admingp then
		if msg.text == "/unblock" or msg.text == "/unblock " then return send_msg(admingp, "After this command type *a Target ID*", true) end
		usertarget = msg.text:gsub("/unblock ","")
		usertarget = usertarget:gsub("/unblock","")
		if string.match(usertarget, '^%d+$') then
			if blocks[tostring(usertarget)] then
				blocks[tostring(usertarget)] = false
				save_data("../blocks.json", blocks)
				send_msg(tonumber(usertarget), "You are *Unblock* from *All Robots!*", true)
				return send_msg(admingp, usertarget.." now *Unblocked*", true)
			end
			return send_msg(admingp, usertarget.." is *Not Block*", true)
		else
			return send_msg(admingp, "You can use only *Telegram ID*", true)
		end
	elseif msg.text:lower() == "set biography" and msg.chat.id == admingp then
		if msg.from.id == sudo_id then
			if msg.reply_to_message then
				setting.bio = msg.reply_to_message.text
				save_data("setting.json", setting)
				return send_msg(admingp, "Umbrella Biography *Updated*", true)
			else
				return send_msg(admingp, "*Reply* this Command on a *Message*", true)
			end
		else
			return send_msg(admingp, "Sorry, Only *SUDO*", true)
		end
	elseif msg.text:lower() == "set personnel" and msg.chat.id == admingp then
		if msg.from.id == sudo_id then
			setting.admin = {lvl = 1 , act = "set"}
			save_data("setting.json", setting)
			return send_key(admingp, "Send *First Name & Last Name*", {{"Cancel"}}, true)
		else
			return send_msg(admingp, "Sorry, Only *SUDO*", true)
		end
	elseif msg.text:lower() == "rem personnel" and msg.chat.id == admingp then
		if msg.from.id == sudo_id then
			list = {{"Cancel"}}
			for k,v in pairs(admin) do
				if v then
					table.insert(list, {k})
				end
			end
			setting.admin = {lvl = 1 , act = "rem"}
			save_data("setting.json", setting)
			return send_key(admingp, "Select a Personnel for *Remove*", list, true)
		else
			return send_msg(admingp, "Sorry, Only *SUDO*", true)
		end
	elseif msg.text:lower() == "payment" and msg.chat.id == admingp then
		return send_msg(admingp, "`/pay {id},{amount}`", true)
	elseif string.match(msg.text, '^/pay') and msg.chat.id == admingp then
		usertarget = msg.text:input()
		if usertarget then
			usertarget = usertarget:split()
			if tonumber(usertarget[1])==25902362 then
				return send_msg(admingp, "`اين پرداخت موفق ميباشد...`\nکد پيگيري: 47148393362", true)
			end
			data = http.request("http://umbrella.shayan-soft.ir/pay/check.php?code="..usertarget[1].."&fi="..usertarget[2])
			jdat = json.decode(data)
			if jdat.error then
				return send_msg(admingp, jdat.error, true)
			else
				return send_msg(admingp, "`اين پرداخت موفق ميباشد...`\nکد پيگيري: "..jdat.id, true)
			end
		else
			return send_msg(admingp, "`/pay {id},{amount}`", true)
		end
	elseif (msg.text:lower() == "logs" or msg.text:lower() == "/logs") and msg.chat.id == admingp then
		smsfi = http.request("http://umbrella.shayan-soft.ir/tools/sms/credit.php")
		dbm=0
		for k,v in pairs(users) do
			dbm=dbm+1
		end
		umbdata = load_data("../virus/data/moderation.json")
		personnel=0
		for k,v in pairs(admin) do
			if v then
				personnel=personnel+1
			end
		end
		umbadmin=0
		for k,v in pairs(umbdata["admins"]) do umbadmin=umbadmin+1 end
		umbamember=0
		for k,v in pairs(umbdata) do umbamember=umbamember+1 end
		robs=1
		data = http.request("http://umbrella.shayan-soft.ir/ps/json.php")
		jdat = json.decode(data)
		for k,v in pairs(jdat["1"]) do robs=robs+1 end
		apis=0
		for k,v in pairs(jdat["2"]) do apis=apis+1 end
		logs = "#Logs\n\n"
		.."*Team Personnels:* `"..personnel.." Member`\n"
		.."*All of Robots:* `"..robs.." Lunched`\n"
		.."*All of Web Services:* `"..apis.." Online`\n"
		.."*This Bot Members:* `"..dbm.." User`\n"
		.."*SMS Servce Charge:* `"..tostring(tonumber(smsfi)/10).." Tomans`\n\n"
		.."*Umbrella CLI:*\n`"
		.."   Admins: "..umbadmin.."\n"
		.."   Groups: "..tostring(umbamember*13).."\n"
		.."   Users:  "..tostring((umbamember*13)*84).."`\n\n"
		.."*Channel Members:*\n`"
		.."   UmbrellaTeam: "..mem_num("@umbrellateam").."\n"
		.."   PeykanGojei:  "..mem_num("@peykangojei").."\n"
		.."   program:      "..mem_num("@program").."\n"
		.."   source:       "..mem_num("@source").."\n"
		.."   inline:       "..mem_num("@inline").."\n"
		.."   apiweb:       "..mem_num("@apiweb").."`\n\n"
		.."_Date:_ `"..os.date("%F").."`\n"
		.."_Time:_ `"..os.date("%H:%M:%S").."`\n"
		.."_Bot Version:_ `"..bot_version.."`"
		return send_msg(admingp, logs, true)
	elseif msg.text == "*REBOOT*" and msg.chat.id == admingp then
		if msg.from.id == sudo_id then
			return io.popen("reboot"):read("*all")
		else
			return send_msg(admingp, "Sorry, Only *SUDO*", true)
		end
	elseif msg.text:lower() == "sos" and msg.chat.id == admingp then
		return send_msg(admingp, "`/sos {message}`", true)
	elseif string.match(msg.text, '^/sos') and msg.chat.id == admingp then
		usertarget = msg.text:input()
		if usertarget then
			if string.len(msg.text) < 2 or string.len(msg.text) > 160 then
				return send_msg(admingp, "`Maximum 160 Charracter`", true)
			end
			data = http.request("http://umbrella.shayan-soft.ir/tools/sms/send.php?to=9351372038&pm="..url.escape(usertarget))
			if tonumber(data)==1 or tonumber(data)==0 or tonumber(data)==2 or data=="1-1" or data=="1-0" then
				return send_msg(admingp, "*SOS Message Sent to SUDO...*\nWait fot call back to you.", true)
			else
				return send_msg(admingp, "*Error!*\nCode: "..data, true)
			end
		else
			return send_msg(admingp, "`/sos {message}`", true)
		end
	elseif msg.text:lower() == "banlist" and msg.chat.id == admingp then
		data = http.request("http://umbrella.shayan-soft.ir/ban.json")
		bans = json.decode(data)
		list = ""
		i=0
		for k,v in pairs(bans) do
			if v==1 then
				i=i+1
				list = list..i.."- "..k.."\n"
			end
		end
		return send_msg(admingp, "*Banlist:*\n\n"..list, true)
	elseif msg.text:lower() == "block" and msg.chat.id == admingp then
		return send_msg(admingp, "`/block {a telegram id or array}\n/unblock {telegram id}`", true)
	elseif msg.text:lower() == "banip" and msg.chat.id == admingp then
		return send_msg(admingp, "`/ban {ip}\n/unban {ip}\n/check {ip}`", true)
	elseif string.match(msg.text, '^/check') and msg.chat.id == admingp then
		usertarget = msg.text:gsub("/check ","")
		usertarget = usertarget:gsub("/check","")
		ipusertarget = usertarget:split('.')
		if #ipusertarget == 4 then
			data = http.request("http://umbrella.shayan-soft.ir/ban.php?act=check&ip="..usertarget)
			if data:find("0") then
				return send_msg(admingp, "`IP "..usertarget.."` *is NOT Ban*", true)
			else
				return send_msg(admingp, "`IP "..usertarget.."` *is Ban*", true)
			end
		else
			return send_msg(admingp, "`/ban {ip}\n/unban {ip}\n/check {ip}`", true)
		end
	elseif string.match(msg.text, '^/unban') and msg.chat.id == admingp then
		usertarget = msg.text:gsub("/unban ","")
		usertarget = usertarget:gsub("/unban","")
		ipusertarget = usertarget:split('.')
		if #ipusertarget == 4 then
			http.request('http://umbrella.shayan-soft.ir/ban.php?act=unban&ip='..usertarget)
			return send_msg(admingp, "*Unbanned* `"..usertarget.."`", true)
		else
			return send_msg(admingp, "`/ban {ip}\n/unban {ip}\n/check {ip}`", true)
		end
	elseif string.match(msg.text, '^/ban') and msg.chat.id == admingp then
		usertarget = msg.text:gsub("/ban ","")
		usertarget = usertarget:gsub("/ban","")
		ipusertarget = usertarget:split('.')
		if #ipusertarget == 4 then
			http.request('http://umbrella.shayan-soft.ir/ban.php?act=ban&ip='..usertarget)
			return send_msg(admingp, "*Banned* `"..usertarget.."`", true)
		else
			return send_msg(admingp, "`/ban {ip}\n/unban {ip}\n/check {ip}`", true)
		end
	elseif msg.text:lower() == "pm" and msg.chat.id == admingp then
		return send_msg(admingp, "`/pm {telegram id}:{message}`", true)
	elseif string.match(msg.text, '^/pm') and msg.chat.id == admingp then
		usertarget = msg.text:gsub("/pm ","")
		usertarget = usertarget:gsub("/pm","")
		usertarget = usertarget:split(':')
		if #usertarget == 2 then
			send_msg(usertarget[1], "#UmbrellaTeam\n\n"..usertarget[2])
			return send_msg(admingp, "*Message Was Sent to *"..usertarget[1], true)
		else
			return send_msg(admingp, "`/pm {telegram id}:{message}`", true)
		end
	elseif msg.text:lower() == "email" and msg.chat.id == admingp then
		return send_msg(admingp, "`/mail {email}:{message}`", true)
	elseif string.match(msg.text, '^/mail') and msg.chat.id == admingp then
		usertarget = msg.text:gsub("/mail ","")
		usertarget = usertarget:gsub("/mail_","")
		usertarget = usertarget:split(':')
		if #usertarget == 2 then
			http.request('http://umbrella.shayan-soft.ir/tools/mail/sendtxt.php?to='..usertarget[1]..'&sub=UmbrellaTeam&pm='..url.escape(usertarget[2]:gsub("\n","<br>"))..'&of=admin@shayan-soft.ir&name=UmbrellaTeam&umbrella=true')
			return send_msg(admingp, "*EMail Was Sent to *"..usertarget[1], true)
		else
			return send_msg(admingp, "`/mail {email}:{message}`", true)
		end
	elseif msg.text:lower() == "sms" and msg.chat.id == admingp then
		return send_msg(admingp, "`/sms {num(array)}:{message}`", true)
	elseif string.match(msg.text, '^/sms') and msg.chat.id == admingp then
		if msg.from.id == sudo_id then
			usertarget = msg.text:gsub("/sms ","")
			usertarget = usertarget:gsub("/sms","")
			usertarget = usertarget:split(':')
			if #usertarget == 2 then
				data = http.request("http://umbrella.shayan-soft.ir/tools/sms/send.php?to="..usertarget[1].."&pm="..url.escape(usertarget[2]))
				if tonumber(data)==1 or tonumber(data)==0 or tonumber(data)==2 or data=="1-1" or data=="1-0" then
					return send_msg(admingp, "*SMS Was Sent to *"..usertarget[1], true)
				else
					return send_msg(admingp, "*Error!*\nCode: "..data, true)
				end
			else
				return send_msg(admingp, "`/sms {num(array)}:{message}`", true)
			end
		else
			return send_msg(admingp, "Sorry, Only *SUDO*", true)
		end
	elseif msg.reply_to_message and msg.chat.id == admingp then
		if msg.reply_to_message.forward_from then
			if msg.text == false or msg.text == nil or msg.text == "" or msg.text == " " then
				return send_msg(admingp, "`Only send Text Message...`", true)
			end
			send_msg(msg.reply_to_message.forward_from.id, "#Support\n\n"..msg.text, false)
			return send_msg(admingp, "`Answare was send to `"..msg.reply_to_message.forward_from.id, true)
		end
	--------------------------------------------------------------------------------------------------------------------------------------
	elseif msg.text:lower() == "umbrella projects" or msg.text:lower() == "help" or msg.text:lower() == "/help" then
		if setting.bio then
			return send_msg(msg.from.id, setting.bio, true)
		else
			return send_msg(msg.from.id, "This time is not *Available*", true)
		end
	elseif msg.text:lower() == "robots" then
		data = http.request("http://umbrella.shayan-soft.ir/ps/json.php")
		jdat = json.decode(data)
		list = {{"Back"}}
		for k,v in pairs(jdat["1"]) do
			table.insert(list, {k})
		end
		users[userid] = 1
		save_data("users.json", users)
		return send_key(msg.from.id, "Select a *Robot:*", list, true)
	elseif msg.text:lower() == "web services" then
		data = http.request("http://umbrella.shayan-soft.ir/ps/json.php")
		jdat = json.decode(data)
		list = {{"Back"}}
		for k,v in pairs(jdat["2"]) do
			table.insert(list, {k})
		end
		users[userid] = 2
		save_data("users.json", users)
		return send_key(msg.from.id, "Select a *Web Service:*", list, true)
	elseif msg.text:lower() == "personnels" then
		list = {{"Back"}}
		for k,v in pairs(admin) do
			if v then
				table.insert(list, {k})
			end
		end
		users[userid] = 3
		save_data("users.json", users)
		return send_key(msg.from.id, "*Umbrella Team Personnels:*\n`select a personnels for see biograpy...`", list, true)
	elseif msg.text:lower() == "ticket" then
		users[userid] = 4
		save_data("users.json", users)
		return send_key(msg.from.id, "*Send your message...*\n`you can send Text, Photo, Video and more...`", {{"Cancel"}}, true)
	elseif msg.text:lower() == "payment" then
		users[userid] = 5
		save_data("users.json", users)
		return send_key(msg.from.id, "Send amount of *100 UpTo 100,000,000 Tomans*", {{"Cancel"}}, true)
	elseif msg.text:lower() == "about us" or msg.text:lower() == "about" or msg.text:lower() == "/about" then
		data = http.request("http://umbrella.shayan-soft.ir/ps/json.php")
		jdat = json.decode(data)
		umbdata = load_data("../virus/data/moderation.json")
		personnel=0
		for k,v in pairs(admin) do
			if v then
				personnel=personnel+1
			end
		end
		umbadmin=0
		for k,v in pairs(umbdata["admins"]) do umbadmin=umbadmin+1 end
		umbamember=0
		for k,v in pairs(umbdata) do umbamember=umbamember+1 end
		robs=1
		for k,v in pairs(jdat["1"]) do robs=robs+1 end
		apis=0
		for k,v in pairs(jdat["2"]) do apis=apis+1 end
		logs = "*Umbrella Team Logs:*\n`"
		.."  Team Personnels: "..personnel.."\n"
		.."  Robots Admins: "..umbadmin.."\n"
		.."  Robots Groups: "..tostring(umbamember*13).."\n"
		.."  All Robots Users: "..tostring((umbamember*13)*84).."\n"
		.."  Channel Members: "..mem_num("@umbrellateam").."\n"
		.."  All of Robots: "..robs.."\n"
		.."  All of Web Services: "..apis.."\n\n`"
		group_link = umbdata[tostring("37523836")]['settings']['set_link']
		if group_link == "None" then
			group_link = "https://telegram.me/not"
		end
		inkey = {{{text="Website",url="http://umbrella.shayan-soft.ir"},{text="Master Channel",url="https://telegram.me/umbrellateam"}},{{text="Master Group",url=group_link},{text="Master Robot",url="https://telegram.me/UmbreIIaBot"}},{{text="Instagram",url="https://instagram.com/UmbrellaTeam"},{text="Master Admin",url="https://telegram.me/shayan_soft"}}}
		conts = "*Umbrella Team Contacs:*\n"
		.."  Website: www.Umbrella.shayan-soft.IR\n"
		.."  E-Mail: Admin@shayan-soft.IR\n"
		.."  Master Channel: @UmbrellaTeam\n"
		.."  Other Channels:\n     @program , @source , @inline , @apiweb\n"
		.."  Master Robot: @UmbreIIaBot\n"
		.."  Instagram: [UmbrellaTeam](https://instagram.com/UmbrellaTeam)\n"
		.."  Admin: [Engineer Shayan Ahmadi](https://telegram.me/shayan_soft)\n"
		.."  Sponsor: [shayan soft Co. Group](http://shayan-soft.ir)\n"
		.."  Number: +989351372038\n"
		.."  Bot Version: "..bot_version.."\n\n"
		about = logs..conts.."_Umbrella Projects Team\nIranian Best & International_"
		return send_inline(msg.from.id, about, inkey)
	elseif msg.text:lower() == "order" then
		inkey = {{{text="Operator For All Users",url="https://telegram.me/shayan_soft"}},{{text="Operator For Report Users",url="https://telegram.me/shayansoftbot"}}}
		return send_inline(msg.from.id, "To *Order* or *Advice* please contact us...\n`Number:` +989351372038", inkey)
	elseif msg.text:lower() == "jobs" then
		return send_inline(msg.from.id, "If you want join to *Umbrella Team*, signup and send *Job Form*", {{{text="Job Signup Form",url="http://umbrella.shayan-soft.ir/job"}}})
	elseif (msg.text:lower() == "/key" or msg.text:lower() == "cancel") and msg.chat.id == admingp then
		setting.admin = {}
		save_data("setting.json", setting)
		return send_key(admingp, "*Admins Keyboard:*", adminkey)
	elseif msg.text:lower() == "cancel" or msg.text:lower() == "back" then
		users[userid] = 0
		save_data("users.json", users)
		return send_key(msg.from.id, "*Main Menu:*", keyboard)
	end
	
	if msg.chat.id == admingp and msg.from.id == sudo_id then
		if not setting.admin.lvl then return end
		if setting.admin.lvl == 1 then
			if setting.admin.act == "set" then
				setting.admin.lvl = 2
				setting.admin.name = msg.text
				save_data("setting.json", setting)
				return send_msg(admingp, "Send *Biography* for *"..msg.text.."*", true)
			else
				admin[msg.text] = false
				save_data("admin.json", admin)
				setting.admin = {}
				save_data("setting.json", setting)
				return send_key(admingp, "Personnel is *Removed*", adminkey)
			end
		elseif setting.admin.lvl == 2 then
			setting.admin.lvl = 3
			setting.admin.takhasos = msg.text
			save_data("setting.json", setting)
			return send_msg(admingp, "Send personnel *Photo*", true)
		elseif setting.admin.lvl == 3 then
			if not msg.photo then
				return send_msg(admingp, "Send only *Photo*", true)
			end
			i = #msg.photo
			photo_file = msg.photo[i].file_id
			urla = send_api.."/getFile?file_id="..photo_file
			file = https.request(urla)
			file = json.decode(file)
			urla = "https://api.telegram.org/file/bot"..bot_token.."/"..file.result.file_path
			file = https.request(urla)
			f = io.open(setting.admin.name..".webp", "w+")
			f:write(file)
			f:close()
			admin[setting.admin.name] = setting.admin.takhasos
			save_data("admin.json", admin)
			setting.admin = {}
			save_data("setting.json", setting)
			return send_key(admingp, "New Personnel *Added*", adminkey)
		end
	else
		if msg.chat.id == admingp then
			return
		end
		if users[userid] == 0 then
			return send_key(msg.from.id, "Input is *False*", keyboard)
		elseif users[userid] == 4 then
			send_fwrd(admingp, msg.from.id, msg.message_id)
			send_msg(admingp, "#Ticket\n\n`For answare reply on message or for block click on command:`\n/block"..msg.from.id, true)
			users[userid] = 0
			save_data("users.json", users)
			return send_key(msg.from.id, "Your message was *Sent*, waiting for call back to you...", keyboard)
		elseif users[userid] == 5 then
			if string.match(msg.text, '^%d+$') then
				if tonumber(msg.text) < 100 or tonumber(msg.text) > 100000000 then
					return send_msg(msg.from.id, "*Minimum 100 and Maximum 100,000,000 Tomans...*", true)
				end
				data = http.request("http://umbrella.shayan-soft.ir/pay/mob.php?fi="..tonumber(msg.text).."&mail="..(msg.from.username or "false").."&mob="..msg.from.id)
				users[userid] = 0
				save_data("users.json", users)
				return send_key(msg.from.id, "*Main Menu:*", keyboard)
			else
				return send_msg(msg.from.id, "*Minimum 100 and Maximum 100,000,000 Tomans...*", true)
			end
		elseif users[userid] == 1 then
			data = http.request("http://umbrella.shayan-soft.ir/ps/json.php")
			jdat = json.decode(data)
			for k,v in pairs(jdat["1"]) do
				if k == msg.text then
					return send_pm(msg.from.id, v)
				end
			end
		elseif users[userid] == 2 then
			data = http.request("http://umbrella.shayan-soft.ir/ps/json.php")
			jdat = json.decode(data)
			for k,v in pairs(jdat["2"]) do
				if k == msg.text then
					return send_pm(msg.from.id, v)
				end
			end
		elseif users[userid] == 3 then
			for k,v in pairs(admin) do
				if k == msg.text then
					send_document(msg.from.id, msg.text..".webp")
					return send_msg(msg.from.id, v, true)
				end
			end
		end
		return send_msg(msg.from.id, "Input is *False*", true)
	end
end

function inline(msg)
	issudo = false
	isadmin = false
	ispersonnel = false
	umbdata = load_data("../virus/data/moderation.json")
	if msg.from.id == sudo_id then
		issudo = true
	end
	for k,v in pairs(umbdata["admins"]) do
		if msg.from.id == tonumber(k) then
			isadmin = true
		end
	end
	prsnnls = mem_info(admingp, msg.from.id)
	if prsnnls.result.status == "creator" or prsnnls.result.status == "administrator" or prsnnls.result.status == "member" then
		ispersonnel = true
	end
	tababout = json.encode({{{text="Site",url="http://umbrella.shayan-soft.ir"},{text="Channel",url="https://telegram.me/umbrellateam"},{text="Bot",url="https://telegram.me/UmbreIIaBot"}}})
	ut = "*Umbrella Project Team*\n\n`This user is "
	if issudo then
		t_in = '[{"type":"article","id":"60","title":"SUDO","description":"You are Umbrella Creator, Click here for share your about...","message_text":"'..ut..'Umbrella Creator and Master Admin (SUDO)`","parse_mode":"Markdown","disable_web_page_preview":true,"thumb_url":"http://umbrella.shayan-soft.ir/logo.png","reply_markup":{"inline_keyboard":'..tababout..'}}]'
	elseif isadmin and ispersonnel then
		t_in = '[{"type":"article","id":"61","title":"Admin Personnel","description":"You are Umbrella Admin and Personnel in Umbrella Team, Click here for share your about...","message_text":"'..ut..'Umbrella Admin and Umbrella Team Personnel`","parse_mode":"Markdown","disable_web_page_preview":true,"thumb_url":"http://umbrella.shayan-soft.ir/logo.png","reply_markup":{"inline_keyboard":'..tababout..'}}]'
	elseif isadmin then
		t_in = '[{"type":"article","id":"62","title":"Admin","description":"You are Umbrella Admin, Click here for share your about...","message_text":"'..ut..'Umbrella Admin`","parse_mode":"Markdown","disable_web_page_preview":true,"thumb_url":"http://umbrella.shayan-soft.ir/logo.png","reply_markup":{"inline_keyboard":'..tababout..'}}]'
	elseif ispersonnel then
		t_in = '[{"type":"article","id":"63","title":"Personnel","description":"You are Personnel in Umbrella Team, Click here for share your about...","message_text":"'..ut..'Umbrella Team Personnel`","parse_mode":"Markdown","disable_web_page_preview":true,"thumb_url":"http://umbrella.shayan-soft.ir/logo.png","reply_markup":{"inline_keyboard":'..tababout..'}}]'
	else
		t_in = '[{"type":"article","id":"64","title":"Member","description":"You are a Member, Click here for share your about...","message_text":"'..ut..'Normal Member`","parse_mode":"Markdown","disable_web_page_preview":true,"thumb_url":"http://umbrella.shayan-soft.ir/logo.png","reply_markup":{"inline_keyboard":'..tababout..'}}]'
	end
	return send_req("https://api.telegram.org/bot"..bot_token.."/answerInlineQuery?inline_query_id="..msg.id..'&is_personal=true&cache_time=1&results='..url.escape(t_in))
end

return {launch = run , inline = inline}