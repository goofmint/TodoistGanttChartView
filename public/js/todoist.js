// Generated by CoffeeScript 1.10.0
(function() {
  $(function() {
    $("#auth_token").on('change', function(e) {
      var token;
      token = $("#auth_token").val();
      return $.ajax({
        url: "/projects",
        type: "GET",
        dataType: "json",
        data: {
          token: token
        },
        success: function(data) {
          $("#projects").empty();
          console.log(data);
          return $.each(data.results.projects, function(i, project) {
            return $("#projects").append($("<option>").html(project.name).val(project.id));
          });
        }
      });
    });
    return $("#projects").on('change', function(e) {
      var project_id, token;
      project_id = $("#projects").val();
      token = $("#auth_token").val();
      return $.ajax({
        url: "/items",
        type: "GET",
        dataType: "json",
        data: {
          token: token,
          project_id: project_id
        }
      }).then(function(data) {
        var tasks;
        tasks = [];
        $.each(data.results.items, function(i, params) {
          var from, matches, name;
          console.log(params);
          if (params.project_id !== parseInt(project_id)) {
            return;
          }
          matches = params.content.match(/^(.*)\(([0-9]{4}-[0-9]{2}-[0-9]{2})\)$/);
          if (matches) {
            name = matches[1];
            from = Date.parse(matches[2]);
          } else {
            name = params.content;
            from = new Date();
          }
          tasks.push({
            name: name,
            values: [
              {
                from: "/Date(" + from + ")/",
                to: "/Date(" + (Date.parse(params.due_date_utc)) + ")/",
                label: ""
              }
            ]
          });
          console.log(tasks);
          return $(".gantt").gantt({
            source: tasks
          });
        });
        return {
          navigate: "scroll",
          maxScale: "hours",
          itemsPerPage: 20,
          onItemClick: function(data) {},
          onAddClick: function(dt, rowId) {},
          onRender: function() {}
        };
      });
    });
  });

}).call(this);
