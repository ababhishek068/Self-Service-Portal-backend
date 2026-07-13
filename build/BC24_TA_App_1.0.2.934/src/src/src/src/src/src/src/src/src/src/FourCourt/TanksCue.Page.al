page 51438 "Tanks Cue"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Tanks;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Tank Code"; Rec."Tank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tank Code field.';

                }

                field("Station Code"; Rec."Station Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Station Code field.';

                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fuel Type field.';

                }
                field("Availlable Quantity"; Rec."Availlable Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Availlable Quantity field.';

                }

            }


        }


    }
    trigger OnOpenPage()
    var
        UserRec: Record "User Setup";
    begin
        if UserRec.get(Database.UserId) then begin
            if UserRec."Global Dimension 1 Code" <> '' then
                Rec.Setfilter("Station Code", UserRec."Global Dimension 1 Code");
        end;
    end;
}