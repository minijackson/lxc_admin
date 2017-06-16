import {Socket} from "phoenix"

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

let update_socket = function(channel_name, callback, interval = 2000) {

	let socket = new Socket("/socket", {params: {token: window.userToken}})
	socket.connect()
	let channel = socket.channel(channel_name)

	channel.on("update", callback)

	channel.join()
		.receive("ok", resp => {
			console.info("Joined successfully", channel_name, resp)
			window.setInterval(() => channel.push("update", {}), interval)
		})
		.receive("error", resp => { console.warn("Unable to join", channel_name, resp) })
}

export var update_container_info = function(container_name, verbosity) {

	let state_el = document.querySelector("#state");
	let channel_name = "container_info:" + container_name

	update_socket(channel_name, payload => {
		console.info("Infos received")
		console.table(payload)
		state_el.innerHTML = payload.state
	})
}

let replace_action_links = function(template, container_name, href_format, action_format) {
	let links = template.content.querySelectorAll("a.btn.btn-xs")

	links.forEach(el => {
		let href = href_format.replace("XXnameXX", container_name)
		el.setAttribute("href", href)
	})

	let form = template.content.querySelector("form")

	let action = action_format.replace("XXnameXX", container_name)
	form.setAttribute("action", action)
}

export var update_containers_short_info = function() {
	if('content' in document.createElement('template')) {

		let template_el = document.querySelector("#container-info-template");

		let template_name = template_el.content.querySelector(".name")
		let template_state = template_el.content.querySelector(".state")
		let template_ip = template_el.content.querySelector(".ip")

		let href_format = template_el.content.querySelector("a.btn.btn-xs").getAttribute("href")
		let action_format = template_el.content.querySelector("td.text-right form").getAttribute("action")

		let containers_tbody = document.querySelector("#containers");

		update_socket("containers_short_info", infos => {
			console.info("Infos received:")
			console.table(infos)

			containers_tbody.innerHTML = "";

			for(let container_name in infos) {
				let container_info = infos[container_name]

				template_name.innerHTML = container_name
				template_state.innerHTML = container_info.state
				template_ip.innerHTML = container_info.ip

				replace_action_links(template_el, container_name, href_format, action_format)

				let template_inst = document.importNode(template_el.content, /* deep = */ true)

				containers_tbody.appendChild(template_inst);
			}
		})
	}
}
