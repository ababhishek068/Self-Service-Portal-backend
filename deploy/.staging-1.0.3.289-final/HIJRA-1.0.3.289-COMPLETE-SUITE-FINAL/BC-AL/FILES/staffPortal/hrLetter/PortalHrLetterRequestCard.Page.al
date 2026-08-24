page 52146 "Portal HR Letter Request Card"
{
    ApplicationArea = All;
    Caption = 'Portal HR Letter Request';
    PageType = Card;
    SourceTable = "Portal HR Letter Request";
    UsageCategory = None;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Letter Type"; Rec."Letter Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Submitted On"; Rec."Submitted On")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Updated On"; Rec."Updated On")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Details)
            {
                Caption = 'Request Details';

                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Required By Date"; Rec."Required By Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Delivery Method"; Rec."Delivery Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Monthly Basic Salary"; Rec."Monthly Basic Salary")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requested Loan Amount"; Rec."Requested Loan Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Urgency Reason"; Rec."Urgency Reason")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(HRDecision)
            {
                Caption = 'HR Decision';

                field("HR Remarks"; Rec."HR Remarks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type the reason before approving or rejecting; the employee sees it in the portal.';
                }
                field("HR Decision By"; Rec."HR Decision By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("HR Decision On"; Rec."HR Decision On")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
