$ ->
  $("#auth_token").on 'change', (e) ->
    token = $("#auth_token").val()
    $.ajax
      url: "/projects",
      type: "GET",
      dataType: "json",
      data:
        token: token
      success: (data) ->
        $("#projects").empty()
        console.log data
        $.each data.results.projects, (i, project) ->
          $("#projects").append $("<option>").html(project.name).val(project.id)
  $("#projects").on 'change', (e) ->
    project_id = $("#projects").val()
    token = $("#auth_token").val()
    $.ajax
      url: "/items",
      type: "GET",
      dataType: "json",
      data:
        token: token
        project_id: project_id
    .then (data) ->
      tasks = []
      $.each data.results.items, (i, params) ->
        console.log(params)
        unless params.project_id == parseInt(project_id)
          return
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
            to:   "/Date(#{Date.parse(params.due_date_utc)})/"
            label: ""
          ]
        console.log(tasks)
        $(".gantt").gantt
          source: tasks
  				navigate: "scroll"
  				maxScale: "hours"
  				itemsPerPage: 20,
  				onItemClick: (data) ->
  				onAddClick: (dt, rowId) ->
  				onRender: ->
