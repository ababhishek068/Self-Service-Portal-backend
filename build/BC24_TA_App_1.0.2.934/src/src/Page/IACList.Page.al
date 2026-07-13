Page 50242 "IAC List"
{
    PageType = List;
    SourceTable = "IAC Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Delivery Note No."; Rec."Delivery Note No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Delivery Note No. field.';
                }

                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Delivery Date field.';
                }

                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract Amount field.';
                }
                field(CommiteePosition; Rec."Commitee Position")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Commitee Position field.';
                }
                field("Name of Coopted Member"; Rec."Name of Coopted Member")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name of Coopted Member field.';
                }
                field(Sign; Rec.Sign)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sign field.';
                }
            }
        }
    }

    actions { }
}

