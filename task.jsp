<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    // Classe interne pour représenter une tâche
    class Task {
        String title;
        String description;
        String dueDate;
        boolean done;

        public Task(String title, String description, String dueDate) {
            this.title = title;
            this.description = description;
            this.dueDate = dueDate;
            this.done = false;
        }

        public void markDone() {
            this.done = true;
        }
    }

    // Récupération de la liste en session
    List<Task> taskList = (List<Task>) session.getAttribute("tasks");
    if (taskList == null) {
        taskList = new ArrayList<>();
        session.setAttribute("tasks", taskList);
    }

    // Gestion des actions
    String action = request.getParameter("action");
    if ("add".equals(action)) {
        String titre = request.getParameter("title");
        String desc = request.getParameter("description");
        String date = request.getParameter("date");
        if (titre != null && !titre.isEmpty()) {
            taskList.add(new Task(titre, desc, date));
        }
    } else if ("done".equals(action)) {
        int index = Integer.parseInt(request.getParameter("index"));
        if (index >= 0 && index < taskList.size()) {
            taskList.get(index).markDone();
        }
    } else if ("delete".equals(action)) {
        int index = Integer.parseInt(request.getParameter("index"));
        if (index >= 0 && index < taskList.size()) {
            taskList.remove(index);
        }
    }
%>

<html>
<head>
    <title>Mini Gestionnaire de Tâches</title>
</head>
<body>
    <h1>Mini Gestionnaire de Tâches</h1>

    <form method="post">
        <input type="hidden" name="action" value="add">
        <p>
            <label for="title">Titre :</label><br/>
            <input type="text" name="title" required>
        </p>
        <p>
            <label for="description">Description :</label><br/>
            <textarea name="description" rows="3" cols="40"></textarea>
        </p>
        <p>
            <label for="date">Date d’échéance :</label><br/>
            <input type="date" name="date">
        </p>
        <input type="submit" value="Ajouter la tâche">
    </form>

    <h2>Liste des Tâches</h2>
    <ul>
        <%
            for (int i = 0; i < taskList.size(); i++) {
                Task t = taskList.get(i);
        %>
            <li>
                <strong><%= t.title %></strong>
                <% if (t.done) { %> <span style="color:green;">[Terminée]</span> <% } %><br/>
                <em><%= t.description %></em><br/>
                <small>Échéance : <%= t.dueDate %></small><br/>

                <form method="post" style="display:inline;">
                    <input type="hidden" name="index" value="<%= i %>">
                    <input type="hidden" name="action" value="done">
                    <% if (!t.done) { %>
                        <input type="submit" value="Marquer comme terminée">
                    <% } %>
                </form>
                <form method="post" style="display:inline;">
                    <input type="hidden" name="index" value="<%= i %>">
                    <input type="hidden" name="action" value="delete">
                    <input type="submit" value="Supprimer">
                </form>
            </li>
            <hr/>
        <%
            }
        %>
    </ul>
</body>
</html>
