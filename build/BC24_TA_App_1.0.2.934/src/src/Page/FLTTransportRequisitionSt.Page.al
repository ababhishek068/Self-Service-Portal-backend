page 50619 "FLT Transport Requisition St"
{
    PageType = ListPart;
    SourceTable = "FLT-Travel Requisition Staff";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Passenger Type"; Rec."Passenger Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Passenger Type field.';
                }
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                    trigger OnValidate()
                    var
                        Emp: record "HR-Employee";
                    begin
                        if Emp.get(Rec.No) then
                            Rec.Position := emp."Job Title";
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }
            }
        }
    }

    actions { }
}

