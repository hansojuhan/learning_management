/*
This JavaScript class adds sortable functionality to elements on a web page, specifically targeting lessons within a course. When a user changes the order of lessons by dragging and dropping, the onUpdate method sends an update to the server with the new position of the moved lesson, ensuring the server's data matches the order displayed on the page. It's a practical example of how modern web applications can interact with the server asynchronously to update data in real-time without needing to reload the page.
*/ 

// This line imports the Controller class from the Stimulus framework.
import { Controller } from "@hotwired/stimulus"
// This imports the Sortable library which is a Stimulus controller that 
// adds drag-and-drop sorting capabilities to a list of elements.
import Sortable from 'stimulus-sortable'

// Connects to data-controller="lesson"
// Added this in the index page

/* This line defines a new JavaScript class that extends (inherits from) the Sortable class. 
This means it will have all the sorting functionality of Sortable, with some custom behavior added. 
The export default part makes this class available for import in other JavaScript files. */
export default class extends Sortable {
  /*
  This defines a "value" that the controller can use, which is a way of passing 
  data from the HTML to the Stimulus controller. In this case, it expects a course 
  value that is a number. This is likely used to identify which course the lessons belong to.
  */ 
  static values = { course: Number }

  /* 
  This is a method that gets called automatically when the list's order is changed (i.e., 
  when an item is dragged and dropped to a new position). It overrides (customizes) 
  the onUpdate method from the Sortable class. 
  */ 
  onUpdate(event){
    // This calls the onUpdate method of the parent Sortable class, ensuring that 
    // the basic sorting functionality is performed before executing the custom code.
    super.onUpdate(event)

    const newIndex = event.newIndex

    // This extracts the id of the item that was moved from the event object.
    const id = event.item.id

    // This retrieves the course ID that was defined earlier in static values. 
    // This tells the server which course the lesson belongs to.
    const courseId = this.courseValue

    /*
    This is a function that makes an HTTP request to the server. In this context, 
    it's used to send a PATCH request to a specific URL. This request is meant to 
    inform the server of the new position of the lesson that was moved.

    The URL /admin/course/${courseId}/lessons/${id}/move is a template string 
    that includes the courseId and id of the moved lesson, telling the server 
    which lesson of which course was moved.

    The body: JSON.stringify({ position: newIndex, id: id }) part is the data sent 
    with the request, specifying the new position and the ID of the lesson
    */ 

    // Console log this
    console.log("CSRF token:", document.querySelector('[name="csrf-token"]').content)

    // Gotta use ` ` around the url
    fetch(`/admin/course/${courseId}/lessons/${id}/move`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ position: newIndex, id: id })
    })
  }
}
