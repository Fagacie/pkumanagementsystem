/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */



document.addEventListener('DOMContentLoaded', function() {
    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.getElementById('sidebar');
    
    

    // Add event listener to the toggle button
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
        });
    }

    // Function to adjust sidebar state based on screen size
    function adjustSidebarForScreenSize() {
        if (window.innerWidth <= 768) {
            // On small screens (mobile), ensure sidebar is not collapsed (i.e., menu icon is hamburger)
            // The actual menu display/hide is handled by CSS based on .collapsed class
            sidebar.classList.remove('collapsed');
        } else {
            // On larger screens (desktop), ensure sidebar is expanded by default
            sidebar.classList.remove('collapsed');
        }
    }
    
    
    
    

    // Initial adjustment when the page loads
    adjustSidebarForScreenSize();

    // Listen for window resize events to re-adjust sidebar state
    window.addEventListener('resize', adjustSidebarForScreenSize);
});


