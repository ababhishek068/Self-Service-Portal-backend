Page 51124 "Student hostel Inventory Items"
{
    PageType = List;
    SourceTable = "Student hostel Inventory Items";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ItemCode; Rec."Item Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item Code field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(StudentName; Rec."Student Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Name field.';
                }
                field(HostelBlock; Rec."Hostel Block")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hostel Block field.';
                }
                field(RoomCode; Rec."Room Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Code field.';
                }
                field(SpaceCode; Rec."Space Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Space Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Cleared; Rec.Cleared)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared field.';
                }
            }
        }
    }

    actions { }
}

