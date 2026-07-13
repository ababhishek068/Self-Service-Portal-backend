page 50940 "HR Leave Allocation Entries"
{

    ApplicationArea = All;
    Caption = 'HR Leave Allocation Entries';
    PageType = List;
    SourceTable = "HR Leave Allocation";
    SourceTableView = where(Posted = const(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Application End Date"; Rec."Application End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application End Date field.';
                }
                field("Application Start Date"; Rec."Application Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Start Date field.';
                }
                field("Calendar End Date"; Rec."Calendar End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calendar End Date field.';
                }
                field("Calendar Start Date"; Rec."Calendar Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calendar Start Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave Type field.';
                }
                field("No. Of days"; Rec."No. Of days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Of days field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave Posting Description field.';
                }
                field("Posting Source"; Rec."Posting Source")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Source field.';
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Type field.';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted field.';
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field("Calendar Code"; Rec."Calendar Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calendar Code field.';
                }
                field("Application Return Date"; Rec."Application Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Return Date field.';
                }
            }
        }
    }

}
