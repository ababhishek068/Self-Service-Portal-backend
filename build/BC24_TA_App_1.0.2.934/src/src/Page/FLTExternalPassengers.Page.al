page 50057 "FLT-External Passengers"
{
    Caption = 'FLT-External Passengers';
    PageType = ListPart;
    SourceTable = "FLT-External Passengers";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No field.';
                }
                field("Passenger Names"; Rec."Passenger Names")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Passenger Names field.';
                }
                field("Passenger Organization"; Rec."Passenger Organization")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Passenger Organization field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                
                field("Transport No."; Rec."Transport No.")
                {
                    //Visible=false;
                    Editable = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transport No. field.';
                }

            }
        }
    }
}
