defmodule Issues.GithubIssues do 
	@github_url Application.get_env(:issues, :github_url)	
	@user_agent [ {"User-agent", "tiago.asp.net@gmail.com"} ]	

	def fetch(user, project) do 
		issues_url(user, project)
		|> HTTPoison.get(@user_agent)
		|> handle_response
	end	

	def issues_url(user, project) do 
		"#{@github_url}/repos/#{user}/#{project}/issues"
	end

	#def handle_response(%{status_code: 200, body: body}), do: {:ok, body}	
	#def handle_response(%{status_code: ___, body: body}), do: {:error, body}

	def handle_response({:error, %HTTPoison.Error{reason: error}}), do: {:error, error}

  	def handle_response({:ok, %HTTPoison.Response{status_code: status, body: body}}) 
  	when status >= 400, do: {:error, :jsx.decode(body)}

  	def handle_response({:ok, %HTTPoison.Response{body: body}}), do: {:ok, :jsx.decode(body)}		
end 						