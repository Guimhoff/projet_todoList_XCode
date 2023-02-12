//
//  DetailViewController.swift
//  to-do-list
//
//  Created by Guillaume Imhoff on 05/12/2022.
//

import UIKit

/*
 Classe de la vue détaillée d'une tâche
 */
class DetailViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var textName: UITextField!                   // zone d'affichage et de modification du nom
    @IBOutlet weak var textDetails: UITextView!                 // zone d'affichage et de modification de la description
    @IBOutlet weak var suppButton: UIButton!                    // Bouton de suppression
    @IBOutlet weak var valButton: UIButton!                     // Bouton de validation de la tâche
    @IBOutlet weak var datePicker: UIDatePicker!                // Affichage et modification de la date
    @IBOutlet weak var cancelButton: UIButton!                  // Bouton permettant d'annuler la suppression
    var tableViewDelegate: UpdateTableViewDelegate?             // référence qui permet de mettre à jour l'affichage de la liste des tâches
    
    
    var todo: Todo?                                             // Todo affichée dans la vue
    
    var deletePush = false                                      // Le bouton delete a déjà été pressé une fois
    
    
    /*
     fonction d'initialisation exécutée après le chargement de la vue
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textName.text = todo?.name
        textDetails.text = todo?.description
        datePicker.date = todo?.date ?? Date()
        updateTaskDone()
        textDetails.delegate = self
        cancelButton.isHidden = true
    }
    
    /*
     fonction exécutée quand le nom de la tâche a été modifié
     */
    @IBAction func nameEdited(_ sender: Any) {
        todo?.changeName(newName: textName.text ?? "Error")
        tableViewDelegate?.updateTableView()
    }
    
    /*
     fonction exécutée quand la description de la tâche a été modifiée
     */
    func textViewDidChange(_ textView: UITextView) {
        todo?.description = textDetails.text
    }
    
    /*
     fonction exécutée après l'appui sur le bouton supprimer
     */
    @IBAction func deleteAction(_ sender: Any) {
        if (deletePush){
            // si il y a déjà eu un appui, on supprime la tâche et on ferme la fenêtre
            todo?.delete()
            tableViewDelegate?.updateTableView()
            self.dismiss(animated: true, completion: nil)
        } else {
            // si c'est le premier appui, on fait apparaître le bouton d'annulation et le texte de confirmation
            deletePush = true
            suppButton.setTitle("Valider la suppression ?", for: .normal)
            cancelButton.isHidden = false
        }
        
    }
    
    /*
     fonction appelée lors de l'appui sur le bouton d'annulation, elle remet le bouton d'annulation dans son état initial
     */
    @IBAction func cancelDelete(_ sender: Any) {
        deletePush = false
        suppButton.setTitle("Supprimer", for: .normal)
        cancelButton.isHidden = true
    }
    
    /*
     fonction qui met à jour l'apparence du bouton "valider la tâche" en fonction de l'état de la Todo
     */
    func updateTaskDone() {
        var taskState: String
        if ((todo?.done) == true) {
            taskState = "✓"
        } else {
            taskState = "·"
        }
        valButton!.setTitle(taskState, for: UIControl.State.normal)
        tableViewDelegate?.updateTableView()
    }
    
    /*
     fonction exécutée lors de l'appui sur le bouton "valider la tâche"
     */
    @IBAction func updateDone(_ sender: Any) {
        todo?.changeState()
        updateTaskDone()
        tableViewDelegate?.updateTableView()
    }
    
    /*
     fonction exécutée lors de la modification de la date
     */
    @IBAction func updateDate(_ sender: Any) {
        todo?.changeDate(newDate: datePicker.date)
        tableViewDelegate?.updateTableView()
    }
    
}
