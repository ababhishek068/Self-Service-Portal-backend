page 50452 "New study form page"
{
    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Investigator Information";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Investigator Information';
                field("Code1"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Job No."; Rec."Job No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Job No. field.';
                }
                field("Project Title"; Rec."Project Title")
                {
                    ToolTip = 'Specifies the value of the Project Title field.';
                }
                field("PI Name"; Rec."PI Name")
                {
                    ToolTip = 'Specifies the value of the Principal Investigator Name field.';
                }
                field("PI Postal Address"; Rec."PI Postal Address")
                {
                    ToolTip = 'Specifies the value of the Principal Investigator Postal Address field.';
                }
                field("PI Email"; Rec."PI Email")
                {
                    ToolTip = 'Specifies the value of the Principal Investigator Email field.';
                }
                field("CPI Name"; Rec."CPI Name")
                {
                    ToolTip = 'Specifies the value of the Co. Principal Investigator Name field.';
                }
                field("CPI Postal Address"; Rec."CPI Postal Address")
                {
                    ToolTip = 'Specifies the value of the Co. Principal Investigator Postal Address field.';
                }
                field("CPI Telephone"; Rec."CPI Telephone")
                {
                    ToolTip = 'Specifies the value of the Co. Principal InvestigatorTelephone field.';
                }
                field("CPI Email"; Rec."CPI Email")
                {
                    ToolTip = 'Specifies the value of the Co. Principal Investigator Email field.';
                }
                field("Ampath Consortium Collaborator"; Rec."Ampath Consortium Collaborator")
                {
                    ToolTip = 'Specifies the value of the Need assistance to identify Collaborator? field.';
                }
            }
            group("Study Summary")
            {
                part("Project areas of focus"; "Project areas of focus new")
                {
                    SubPageLink = "Inv. code" = FIELD(Code);
                }
                field("Study Type"; Rec."Study Type")
                {
                    ToolTip = 'Specifies the value of the Study type will be a: field.';
                }
                field("Primary Objectives"; Rec."Primary Objectives")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the List primary objectives field.';
                }
                field("Project Description"; Rec."Project Description")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Provide project description field.';
                }
                part(Deadlines; Deadlines)
                {
                    SubPageLink = "Inv. Code" = FIELD(Code);
                }
                part(Deliverables; Deliverable)
                {
                    SubPageLink = "Inv. Code" = FIELD(Code);
                }
                field(Funding; Rec.Funding)
                {
                    ToolTip = 'Specifies the value of the Seeking funding for project? field.';
                }
                field(Attachment; Rec.Attachment)
                {
                    ToolTip = 'Specifies the value of the Project Attached field.';
                }
                field("Support Description"; Rec."Support Description")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the If no, how will project be supported field.';
                }
                field("Funding Application Deadline"; Rec."Funding Application Deadline")
                {
                    ToolTip = 'Specifies the value of the Funding Application Deadline field.';
                }
                field("Res. & Working Approval"; Rec."Res. & Working Approval")
                {
                    ToolTip = 'Specifies the value of the Received research working group approval? field.';
                }
                field("Ampath Data Anlsys Team App"; Rec."Ampath Data Anlsys Team App")
                {
                    ToolTip = 'Specifies the value of the Received Ampath Data analysis approval? field.';
                }
                field("IREC Approval"; Rec."IREC Approval")
                {
                    ToolTip = 'Specifies the value of the Received IREC approval? field.';
                }
                field("EIPL Approval"; Rec."EIPL Approval")
                {
                    ToolTip = 'Specifies the value of the Received Export/Import Permits for Laboratory Specimens? field.';
                }
            }
            group(Biostatistics)
            {

                field("Study Population"; Rec."Study Population")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Describe study population yoiu plan to work with field.';
                }
                field("Sampling methods"; Rec."Sampling methods")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Describe proposed sampling methods field.';
                }
                field("Dependent Variables"; Rec."Dependent Variables")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Describe dependent variables for this study field.';
                }
                field("Independent Variables"; Rec."Independent Variables")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Describe independent variables included field.';
                }
                field("Project Statistician Name"; Rec."Project Statistician Name")
                {
                    ToolTip = 'Specifies the value of the Project Statistician Name field.';
                }
                field("PS Primary Inst. Affiliation"; Rec."PS Primary Inst. Affiliation")
                {
                    ToolTip = 'Specifies the value of the Project statistician primary institution affiliation field.';
                }
                field("PS Address"; Rec."PS Address")
                {
                    ToolTip = 'Specifies the value of the Project statistician address field.';
                }
                field(PSTelephone; Rec.PSTelephone)
                {
                    ToolTip = 'Specifies the value of the Project Statistician Telephone field.';
                }
                field("PS Fax"; Rec."PS Fax")
                {
                    Caption = 'Project Statistician FAX';
                    ToolTip = 'Specifies the value of the Project Statistician FAX field.';
                }
                field("PS Email"; Rec."PS Email")
                {
                    Caption = 'Project Statistician Emaill';
                    ToolTip = 'Specifies the value of the Project Statistician Emaill field.';
                }
            }
            group("Lab Requirements")
            {
                field("LTA Test  Known"; Rec."LTA Test  Known")
                {
                    ToolTip = 'Specifies the value of the Lab testing algorithm known field.';
                }
                field("LTA Proposal Submission"; Rec."LTA Proposal Submission")
                {
                    ToolTip = 'Specifies the value of the Algorithm included with this proposal submission field.';
                }
                field("LTA Description"; Rec."LTA Description")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Describe proposed testing schedule field.';
                }
                field("Covered Tests"; Rec."Covered Tests")
                {
                    ToolTip = 'Specifies the value of the Are all test lists covered by current test list? field.';
                }
                field("SPR study"; Rec."SPR study")
                {
                    ToolTip = 'Specifies the value of the Special processing requirements required? field.';
                }
                field("SPR Description"; Rec."SPR Description")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Describe special processing required field.';
                }
                field("Sample Storage Requirements"; Rec."Sample Storage Requirements")
                {
                    ToolTip = 'Specifies the value of the Special storage requirements for samples? field.';
                }
                field(SampleStorgePeriod; Rec.SampleStorgePeriod)
                {
                    ToolTip = 'Specifies the value of the How long do samples need to be stored? field.';
                }
                field("SSR Destruction prot"; Rec."SSR Destruction prot")
                {
                    ToolTip = 'Specifies the value of the Special protocol required for sample destruction? field.';
                }
                field("SSR Shipment?"; Rec."SSR Shipment?")
                {
                    ToolTip = 'Specifies the value of the Do samples need to be shipped? field.';
                }
                field("SSR Description"; Rec."SSR Description")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Describe above special requirements field.';
                }
                field("Data Storage Requirements"; Rec."Data Storage Requirements")
                {
                    ToolTip = 'Specifies the value of the Special data storage requirements? field.';
                }
                field("DSR Description"; Rec."DSR Description")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Describe special data storage requirements field.';
                }
                field("Special Requirements"; Rec."Special Requirements")
                {
                    ToolTip = 'Specifies the value of the Special Requirements for laboratory staff? field.';
                }
                field("Odd Working Hours"; Rec."Odd Working Hours")
                {
                    ToolTip = 'Specifies the value of the Is there need for extended working hours field.';
                }
                field("Odd working hours description"; Rec."Odd working hours description")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Describe above field.';
                }
                field("Staff Specification"; Rec."Staff Specification")
                {
                    ToolTip = 'Specifies the value of the Staff Specification field.';
                }
            }
        }
    }

    actions { }
}

