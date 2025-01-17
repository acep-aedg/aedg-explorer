// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import CommunityDropdownController from "controllers/community_dropdown_controller"
application.register('community-dropdown', CommunityDropdownController);