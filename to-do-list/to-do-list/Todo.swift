//
//  Todo.swift
//  to-do-list
//
//  Created by Guillaume Imhoff on 07/11/2022.
//

import Foundation

/*
 Classe qui représente une todo à réaliser
 */
class Todo {
    
    var id: Int?                    // id qui permet d'identifier la tâche uniquement
    var name = "Task's name"        // Nom de la tâche
    var description = ""            // Description de la tâche
    var done = false                // Booléen qui sauvegarde l'état de la tâche (réalisé ou non)
    var date = Date()               // Date à laquelle la tâche doit être réalisée
    
    var todoList: TodoList?         // TodoList à laquelle appartient la Todo
    
    /*
     Constructeur simple
     */
    init(newId: Int, new_name: String, new_task: String) {
        id = newId
        name = new_name
        description = new_task
    }
    
    /*
     Constructeur avancé (pour le debug principalement)
     */
    init(newId: Int, new_name: String, new_task: String, new_done: Bool, newDate: Date) {
        id = newId
        name = new_name
        description = new_task
        done = new_done
        date = newDate
    }
    
    /*
     Setter de done qui force son état
     */
    func setState(state: Bool = true) {
        done = state
        todoList?.updateOrder()
    }
    
    /*
     Setter de done qui change son état
     */
    func changeState() {
        done = !done
        todoList?.updateOrder()
    }
    
    /*
     Setter du nom
     */
    func changeName(newName: String = "newName") {
        name = newName
    }
    
    /*
     Setter de la description
     */
    func changeDescription(newDesc: String) {
        description = newDesc
    }
    
    /*
     Setter de la date
     */
    func changeDate(newDate: Date) {
        date = newDate
        todoList?.updateOrder()
    }
    
    /*
     Setter de la todoList
     */
    func setList(newList: TodoList) {
        todoList = newList
    }
    
    /*
     Supprimer la tâche
     */
    func delete() {
        todoList?.deleteTodo(todo: self)
    }
}
