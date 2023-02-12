//
//  TableViewCell.swift
//  to-do-list
//
//  Created by Guillaume Imhoff on 07/11/2022.
//


import UIKit

/*
 Classe de la vue d'une cellule
 */
class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskName: UILabel?               // texte affichant le nom de la todo
    @IBOutlet weak var taskDone: UIButton!              // bouton permettant de valider la tâche
    @IBOutlet weak var taskDate: UILabel!               // texte affichant la date de la todo
    var tableViewDelegate: UpdateTableViewDelegate?     // référence qui permet de mettre à jour l'affichage de la liste des tâches
    
    var row = 0                                                         // index de la tâche dans la taskList de la TodoList
    var todoList = TodoList()                                           // todoList correspondante
    var todo = Todo(newId: 0, new_name: "place", new_task: "holder")    // todo affichée
    let dateFormatter = DateFormatter()                                 // dateFormatter utilisé pour l'affichage de la date
    
    /*
     fonction qui permet d'attacher la todoList et un index à la cellule
     */
    func setRef(newRow: Int, newTodoList: TodoList){
        row = newRow
        todoList = newTodoList
        todo = todoList.taskList[row]
    }
    
    /*
     fonction exécutée à l'initialisation de la cellule
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.dateFormat = "dd MMM yy"
    }
    
    /*
     fonction exécutée quand la cellule est sélectionnée
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     fonction qui met à jour le nom affiché en fonction du nom de la todo
     */
    func updateName(){
        taskName!.text = todo.name
    }
    
    /*
     fonction qui met à jour l'état du bouton valider et du texte de la cellule en fonction de l'état de la Todo
     */
    func updateDone(){
        var taskState: String
        if (todo.done) {
            taskName?.textColor = UIColor.gray
            taskState = "✓"
        } else {
            taskName?.textColor = UIColor.black
            taskState = "·"
        }
        taskDone!.setTitle(taskState, for: UIControl.State.normal)
        updateDate()
    }
    
    /*
     fonction qui met à jour la couleur de la date en fonction de l'état de la todo et de la date actuelle
     */
    func updateDate() {
        if (todo.done) {
            taskDate.textColor = UIColor.lightGray
        } else if (Calendar.current.startOfDay(for: todo.date) < Calendar.current.startOfDay(for: Date())) {
            taskDate.textColor = UIColor.red
        } else {
            taskDate.textColor = UIColor.darkGray
        }
        taskDate.text = dateFormatter.string(from: todo.date)
    }
    
    /*
     fonction qui met à jour tous les affichages
     */
    func updateDisplay(){
        updateName()
        updateDone()
        updateDate()
    }
    
    /*
     fonction appelée lors de l'appui sur le bouton de validation
     */
    @IBAction func doneButton(_ sender: Any) {
        todo.changeState()
        updateDone()
        tableViewDelegate?.updateTableView()
    }
    
}
