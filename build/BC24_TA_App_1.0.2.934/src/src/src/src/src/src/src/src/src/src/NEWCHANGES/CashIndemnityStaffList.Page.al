namespace ABH_UAT.ABH_UAT;

page 51574 "Cash Indemnity Staff List"
{
    ApplicationArea = All;
    Caption = 'Cash Indemnity Staff List';
    PageType = ListPart;
    SourceTable = "Cash Indeminity Lines";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.', Comment = '%';
                }
                field("Staff No"; Rec."Staff No")
                {
                    ToolTip = 'Specifies the value of the Staff No field.', Comment = '%';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ToolTip = 'Specifies the value of the Staff Name field.', Comment = '%';
                }
                field("Job Group"; Rec."Job Group")
                {
                    ToolTip = 'Specifies the value of the Job Group field.', Comment = '%';
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.', Comment = '%';
                }
                field("Works in?"; Rec."Works in?")
                {
                    ToolTip = 'Specifies the value of the Works in? field.', Comment = '%';
                }
                field("No of Days Worked"; Rec."No of Days Worked")
                {
                    ToolTip = 'Specifies the value of the No of Days Worked field.', Comment = '%';
                }
                field("Calculated Cash Indeminity"; Rec."Calculated Cash Indeminity")
                {
                    ToolTip = 'Specifies the value of the Calculated Cash Indeminity field.', Comment = '%';
                }
                field("Accumulated Cash Indemnity"; Rec."Accumulated Cash Indemnity")
                {
                    ToolTip = 'Specifies the value of the Accumulated Cash Indemnity field.', Comment = '%';
                }
            }
        }
    }
}
