//
//  TodoList.swift
//  to-do-list
//
//  Created by Guillaume Imhoff on 07/11/2022.
//

import Foundation

/*
 Classe qui représente la liste de todos à réaliser
 */
class TodoList {
    
    var taskList: [Todo] = []       // Liste qui répertorie les tâches
    var lastId = -1                 // Dernier id utilisée
    
    /*
     Constructeur
     */
    init() {
        // Exemples de tâches (le retour de la fonction étant utilisé pour l'écran de création de Todo, il est inutile ici)
        addTodo(new_name: "Tâche finie dans les temps", new_task: "Description de la tâche finie dans les temps", new_done: true, new_date: Date(timeIntervalSinceNow: -2*24*60*60))
        addTodo(new_name: "Tâche finie en avance", new_task: "Description de la tâche finie en avance", new_done: true, new_date: Date(timeIntervalSinceNow: 2*24*60*60))
        addTodo(new_name: "Tâche en retard", new_task: "Description de la tâche en retard", new_done: false, new_date: Date(timeIntervalSinceNow: -1*24*60*60))
        addTodo(new_name: "Tâche pour aujourd'hui", new_task: "Description de la tâche pour aujourd'hui")
        addTodo(new_name: "Tâche pour demain", new_task: "Description de la tâche pour demain", new_done: false, new_date: Date(timeIntervalSinceNow: 24*60*60))
    }
    
    /*
     Change l'état de la tâche au rang désigné dans la liste
     */
    func changeState(row: Int){
        taskList[row].changeState()
    }
    
    /*
     Ajoute une todo et retourne l'id de la todo ainsi créée
     */
    func addTodo(new_name: String, new_task: String) -> Int {
        return addTodo(new_name: new_name, new_task: new_task, new_done: false, new_date: Date())
    }
    
    /*
     Ajoute une todo et retourne l'id de la todo ainsi créée (fonction avancée utilisée pour le debugging)
     */
    func addTodo(new_name: String, new_task: String, new_done: Bool, new_date: Date) -> Int {
        lastId += 1
        let newTodo = Todo(newId: lastId, new_name: new_name, new_task: new_task, new_done: new_done, newDate: new_date)
        newTodo.setList(newList: self)
        taskList.append(newTodo)
        updateOrder()
        return newTodo.id!
    }
    
    /*
     Retourne la todo correspondant à l'id fournie
     */
    func findTodo(id: Int) -> Todo? {
        for todo in taskList {
            if todo.id == id {
                return todo
            }
        }
        return nil
    }
    
    /*
     supprime la todo fournie
     */
    func deleteTodo(todo: Todo) {
        for (index, task) in taskList.enumerated() {
            if (task.id == todo.id) {
                taskList.remove(at: index)
            }
        }
    }
    
    /*
     met à jour l'ordre des todos dans la liste (selon d'abord l'état de la tâche puis selon la date)
     */
    func updateOrder() {
        taskList.sort {
            if $0.done != $1.done {
                return !$0.done
            } else {
                return $0.date < $1.date
            }
        }
    }
}


