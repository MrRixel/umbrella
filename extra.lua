function send_fwrd(chat_id, from_id, msg_id)
	local urla = send_api.."/forwardMessage?chat_id="..chat_id.."&from_chat_id="..from_id.."&message_id="..msg_id
	return send_req(urla)
end

function send_phone(chat_id, number, name)
	local urla = send_api.."/sendContact?chat_id="..chat_id.."&phone_number="..url.escape(tonumber(number)).."&first_name="..url.escape(name)
	return send_req(urla)
end

function string:split(sep)
	local sep, fields = sep or ",", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function send_inline(chat_id, text, keyboard)
	local response = {}
	response.inline_keyboard = keyboard
	local responseString = json.encode(response)
	local sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	return send_req(sended)
end

function mem_num(chat_id)
	local send = send_api.."/getChatMembersCount?chat_id="..chat_id
	memnum = send_req(send)
	return memnum.result
end

function mem_info(chat_id, user_id)
	local send = send_api.."/getChatMember?chat_id="..chat_id.."&user_id="..user_id
	return send_req(send)
end