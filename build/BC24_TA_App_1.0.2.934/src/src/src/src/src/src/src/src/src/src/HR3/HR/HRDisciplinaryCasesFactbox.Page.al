Page 50405 "HR Disciplinary Cases Factbox"
{
    Caption = 'HR Disciplinary Cases Factbox';
    PageType = CardPart;
    SourceTable = "HR Disciplinary Cases";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(CaseNumber; Rec."Case Number")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Case Number field.';
            }
            field(DateofComplaint; Rec."Date of Complaint")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Date of Complaint field.';
            }
            field(TypeComplaint; Rec."Type of Complaint")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Type of Complaint field.';
            }
            field("Complaint Description"; Rec."Complaint Description")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Complaint Description field.';
            }
            field(RecommendedAction; Rec."Recommended Action")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Recommended Action field.';
            }
            field("More Information"; Rec."More Information")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the More Information field.';
            }
            field(AccuserName; Rec."Accuser Name")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Accuser Name field.';
            }
            field(AccusedEmployeeName; Rec."Accused Employee Name")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Accused Employee Name field.';
            }
            field(Witness1Name; Rec."Witness #1 Name")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Witness #1 Name field.';
            }
            field(Witness2Name; Rec."Witness #2  Name")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Witness #2  Name field.';
            }
            field(ActionTaken; Rec."Action Taken")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Action Taken field.';
            }
            field(DateToDiscussCase; Rec."Date To Discuss Case")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Date To Discuss Case field.';
            }
            field(CaseDiscussion; Rec."Case Discussion")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Case Discussion field.';
            }
            field(ModeofLodgingtheComplaint; Rec."Mode of Lodging the Complaint")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Mode of Lodging the Complaint field.';
            }
            field(BodyHandlingTheComplaint; Rec."Body Handling The Complaint")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Body Handling The Complaint field.';
            }
            field(PolicyGuidlinesInEffect; Rec."Policy Guidlines In Effect")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Policy Guidlines In Effect field.';
            }
            field(ResponsibilityCenter; Rec."Responsibility Center")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Responsibility Center field.';
            }
            field(DisciplinaryStageStatus; Rec."Disciplinary Stage Status")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Disciplinary Stage Status field.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Status field.';
            }
        }
    }

    actions { }
}

