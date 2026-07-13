Page 50000 "Employee Task Allocation List"
{
    PageType = List;
    SourceTable = "Emplyees Task Allocations";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Client; Rec.Client)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Client field.';
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Client Name field.';
                }
                field(Task; Rec.Task)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Task field.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field("Current Status"; Rec."Current Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Status field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("Completion Date"; Rec."Completion Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Completion Date field.';
                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff No field.';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
            }
        }
    }

    actions { }
}

