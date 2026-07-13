Page 51229 "Project Closure List"
{
    PageType = List;
    SourceTable = "Projects Task Closure";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry No field.';
                }
                field("Task Entry No"; Rec."Task Entry No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Task Entry No field.';
                }
                field("Closure Type"; Rec."Closure Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closure Type field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Date field.';
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Date field.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approved By field.';
                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff No field.';
                }
                field("Staff Remarks"; Rec."Staff Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff Remarks field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Client Response"; Rec."Client Response")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Client Response field.';
                }
                field("Client Remarks"; Rec."Client Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Client Remarks field.';
                }
                field("Project No"; Rec."Project No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project No field.';
                }
                field(Customer; Rec.Customer)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer field.';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
                field("Support Issue Description"; Rec."Support Issue Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Support Issue Description field.';
                }
                field("Project Type"; Rec."Project Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Type field.';
                }
            }
        }
    }

    actions { }
}

