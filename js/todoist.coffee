$ ->
  $("#auth_token").on 'change', (e) ->
    token = $("#auth_token").val()
    $.ajax
      url: "https://api.todoist.com//API/getProjects",
      type: "GET",
      dataType: "jsonp",
      data:
        token: token
      success: (data) ->
        $("#projects").empty()
        $.each data, (i, project) ->
          $("#projects").append $("<option>").html(project.name).val(project.id)
  $("#projects").on 'change', (e) ->
    project_id = $("#projects").val()
    token = $("#auth_token").val()
    $.ajax
      url: "https://api.todoist.com/API/getUncompletedItems",
      type: "GET",
      dataType: "jsonp",
      data:
        token: token
        project_id: project_id
      success: (data) ->
        tasks = []
        $.each data, (i, params) ->
          console.log params.content
          matches = params.content.match(/^(.*)\(([0-9]{4}-[0-9]{2}-[0-9]{2})\)$/)
          if matches
            name = matches[1]
            from = Date.parse(matches[2])
          else
            name = params.content
            from = new Date()
          tasks.push
            name: name
            values: [
              from: "/Date(#{from})/"
              to:   "/Date(#{Date.parse(params.due_date)})/"
              label: ""
            ]
        console.log tasks
        $(".gantt").gantt
          source: tasks
  				navigate: "scroll"
  				maxScale: "hours"
  				itemsPerPage: 20,
  				onItemClick: (data) ->
  				onAddClick: (dt, rowId) ->
  				onRender: ->
