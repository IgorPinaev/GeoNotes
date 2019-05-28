//
//  MapController.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 23/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let longTapGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        mapView.gestureRecognizers = [longTapGR]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.removeAnnotations(mapView.annotations)
        for note in notes {
            if note.locationActual != nil {
                mapView.addAnnotation(NoteAnnotation(note: note))
            }
        }
    }
    
    @objc func handleLongTap(recognizer: UIGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        let point = recognizer.location(in: mapView)
        let pointLC = mapView.convert(point, toCoordinateFrom: mapView)
        
        let newNote = Note.newNote(name: "", inFolder: nil)
        newNote.locationActual = LocationCoordinate(lat: pointLC.latitude, lon: pointLC.longitude)
        
        pushNoteController(newNote: newNote)
    }
}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            DispatchQueue.main.async {
               mapView.setCenter(annotation.coordinate, animated: true)
            }
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let selectedNote = (view.annotation as! NoteAnnotation).note
        pushNoteController(newNote: selectedNote)
    }
    
    func pushNoteController(newNote: Note?) {
        let noteController = storyboard?.instantiateViewController(withIdentifier: "noteSID") as! NoteController
        noteController.note = newNote
        navigationController?.pushViewController(noteController, animated: true)
    }
}
