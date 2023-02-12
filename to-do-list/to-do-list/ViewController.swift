//
//  ViewController.swift
//  to-do-list
//
//  Created by Guillaume Imhoff on 07/11/2022.
//

import UIKit

/*
 protocol permettant de mettre à jour la tableView depuis l'extérieur
 */
protocol UpdateTableViewDelegate {
    func updateTableView()
}

/*
 Classe de la vue principale
 */
class ViewController: UIViewController, UITableViewDataSource, UpdateTableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var todoListUI: UITableView!         // TableView qui affiche la liste des Todos
    @IBOutlet weak var searchBar: UISearchBar!          // SearchBar qu'on utilise pour trouver une tâche
    
    var todoList = TodoList()                           // TodoList affichée
    var newTask = false                                 // Booléen qui enregistre si la dernière tâche créée doit être ouverte (cas de l'appuie sur le bouton de création de tâche
    var newId = 0                                       // id de la dernière tâche créée par appuie sur le bouton de création de tâche
    var filteredTasks = [Int]()                         // Liste qui enregistre les positions des tâches filtrées (cas de la recherche de tâche)
    
    /*
     fonction utilisée par la TableView pour connaitre le nombre d'éléments à afficher
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    /*
     fonction qui retourne une cellule en fonction de sa position dans la TableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TableViewCell
        
        let row = indexPath.row
        
        cell.setRef(newRow: filteredTasks[row], newTodoList: todoList)
        cell.tableViewDelegate = self
        
        cell.updateDisplay()
        
        return cell
    }
    
    /*
     fonction d'initialisation exécutée après le chargement de la vue
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        todoListUI.dataSource = self
        searchBar.delegate = self
        
        filterTasks()
    }
    
    /*
     fonction qui filtre en fonction du texte présent dans la barre de recherche et met à jour todoListUI
     */
    func updateTableView() {
        filterTasks()
        todoListUI.reloadData()
    }
    
    /*
     fonction qui met à jour la liste des tâches filtrées
     */
    func filterTasks() {
        let searchText = searchBar.text
        var filteredData = [Int]()
        if (searchText?.isEmpty ?? true) {
            filteredData = todoList.taskList.enumerated().map { $0.0 }
        } else {
            filteredData = todoList.taskList.enumerated().filter { (_, todo) in
                return todo.name.range(of: searchText ?? "", options: .caseInsensitive, range: nil, locale: nil) != nil
            }.map { $0.0 }
        }
        filteredTasks = filteredData
    }
    
    /*
     fonction exécutée lors de l'appui sur le bouton de création de tâche, va ajouter une tâche à la TodoList et l'ouvrir automatiquement
     */
    @IBAction func newTaskButton(_ sender: Any) {
        newId = todoList.addTodo(new_name: "Nouvelle tâche", new_task: "Description de la tâche")
        updateTableView()
        newTask = true
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyBoard.instantiateViewController(withIdentifier: "Detail View Controller") as! DetailViewController
        performSegue(withIdentifier: "detailSegueID", sender: nil)
        self.present(detailViewController, animated: true, completion: nil)
        
    }
    
    /*
     fonction qui prépare l'affichage de la vue détaillée d'une tâche
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController{
            
            if (newTask) {
                // cas d'une nouvelle tâche
                vc.todo = todoList.findTodo(id: newId)
                vc.tableViewDelegate = self
                
                newTask = false
            } else {
                let cell = todoListUI.cellForRow(at: todoListUI.indexPathForSelectedRow!) as! TableViewCell
                    
                    
                vc.todo = cell.todo
                vc.tableViewDelegate = self
            }
        }
    }
    
    /*
     fonction exécutée lors de la modifiction du texte de la barre de recherche
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateTableView()
    }
    
}

