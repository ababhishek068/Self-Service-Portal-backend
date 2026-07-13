Page 50093 "Lecture Rooms - Labs"
{
    PageType = List;
    SourceTable = "Lecture Rooms Labs";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
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
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
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
            }
        }
    }

    actions { }
}

