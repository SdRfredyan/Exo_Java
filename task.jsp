<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>

<%
    // Classe interne
    class Task {
        String title;
        String dueDate;
        boolean done;

        public Task(String title, String dueDate) {
            this.title = title;
            this.dueDate = dueDate;
            this.done = false;
        }

        public void markDone() {
            this.done = true;
        }
    }

    // Initialisation de la liste des tâches en session
    List<Task> taskList = (List<Task>) session.getAttribute("tasks");
    if (taskList == null) {
        taskList = new ArrayList<>();
        session.setAttribute("tasks", taskList);
    }

    // Traitement du formulaire
    String action = request.getParameter("action");
    if ("add".equals(action)) {
        String titre = request.getParameter("title");
        String date = request.getParameter("date");
        if (titre != null && !titre.isEmpty()) {
            taskList.add(new Task(titre, date));
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
        Titre : <input type="text" name="title" required><br/>
        Date d’échéance : <input type="date" name="date"><br/>
        <input type="submit" value="Ajouter">
    </form>

    <h2>Liste des Tâches</h2>
    <ul>
        <%
            for (int i = 0; i < taskList.size(); i++) {
                Task t = taskList.get(i);
        %>
            <li>
                <strong><%= t.title %></strong> - Échéance : <%= t.dueDate %>
                <% if (t.done) { %> <span style="color:green;">[Terminée]</span> <% } %>
                <form method="post" style="display:inline;">
                    <input type="hidden" name="index" value="<%= i %>">
                    <input type="hidden" name="action" value="done">
                    <% if (!t.done) { %><input type="submit" value="Marquer terminée"><% } %>
                </form>
                <form method="post" style="display:inline;">
                    <input type="hidden" name="index" value="<%= i %>">
                    <input type="hidden" name="action" value="delete">
                    <input type="submit" value="Supprimer">
                </form>
            </li>
        <%
            }
        %>
    </ul>
</body>
</html>
