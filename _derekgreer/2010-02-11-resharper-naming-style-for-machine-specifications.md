---
wordpress_id: 222
title: Resharper Naming Style for Machine.Specifications
date: 2010-02-11T01:59:37+00:00
author: Derek Greer
layout: post
wordpress_guid: http://www.aspiringcraftsman.com/?p=222
dsq_thread_id:
  - "317209198"
categories:
  - Uncategorized
tags:
  - Machine.Specifications
  - Resharper
---
If you&#8217;re doing BDD-style specifications and using underscores within your variable names, the default Resharper settings will warn you about violating the naming style rules as shown below:

[<img class="size-full wp-image-223" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperUnconfigured.png" alt="" width="661" height="442" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperUnconfigured.png)

Fortunately, Machine.Specifications (MSpec) extends Resharper to allow for the creation of custom rules which affect only your MSpec types. To create a custom rule for MSpec, follow these steps:

**Step 1**: Open the Resharper Options Dialog.

[<img class="alignnone size-full wp-image-255" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptions.png" alt="" width="229" height="453" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptions.png)

**Step 2**: Navigate to Languages | Naming Style and under &#8220;User defined naming rules&#8221; click &#8220;Add&#8221;.

[<img class="size-full wp-image-224" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyle_add.png" alt="" width="553" height="533" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyle_add.png)

**Step 3**: This displays the &#8220;Edit Extended Naming Rule dialog.  In the &#8220;Rule Definition:&#8221; text box, give your new rule a name such as &#8220;Machine.Specifications Rules&#8221;.

[<img class="alignnone size-full wp-image-261" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyleRuleDescription.png" alt="" width="492" height="446" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyleRuleDescription.png)

**Step 4**: Within the Affected entities list, un-check Class and scroll to the bottom to locate the entries starting with Machine.Specifications. Select all of these entries.

[<img class="alignnone size-full wp-image-260" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyleRuleDescriptionModified.png" alt="" width="492" height="443" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyleRuleDescriptionModified.png)

**Step 5**: Select all options under Access rights: and leave options under Static/non-static: selected.

[<img class="alignnone size-full wp-image-263" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyleAccessRights.png" alt="" width="483" height="190" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyleAccessRights.png)

**Step 6**: Add a new naming style to associate this rule to by clicking the Add icon and selecting the desired naming style (e.g. all_lower).

[<img class="alignnone size-full wp-image-264" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyleRuleStyle.png" alt="" width="224" height="622" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperOptionsLanguagesNamingStyleRuleStyle.png)

The following diagram shows the dialog after these steps:

[<img class="size-full wp-image-249" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperEditExtendedNamingRuleDialog.png" alt="" width="578" height="531" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperEditExtendedNamingRuleDialog.png)

<p style="padding: 10px">
  After selecting OK, Resharper now ignores the naming warnings for the MSpec types:
</p>

<div>
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperConfigured.png"><img class="size-full wp-image-266" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/ResharperConfigured.png" alt="" width="741" height="502" /></a>
</div>
