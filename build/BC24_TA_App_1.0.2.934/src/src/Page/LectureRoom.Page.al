Page 50090 "Lecture Room"
{
    PageType = List;
    SourceTable = "Lecture Room";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(MinimumCapacity; Rec."Minimum Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Capacity field.';
                }
                field(MaximumCapacity; Rec."Maximum Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maximum Capacity field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Facilities; Rec.Facilities)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Facilities field.';
                }
                field(ReserveFor; Rec."Reserve For")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reserve For field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(RoomType; Rec."Room Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Type field.';
                }
                field(LabNo; Rec."Lab No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lab No. field.';
                }
                field(GlobalDimension1; Rec."Global Dimension 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 field.';
                }
            }
        }
    }

    actions { }
}

