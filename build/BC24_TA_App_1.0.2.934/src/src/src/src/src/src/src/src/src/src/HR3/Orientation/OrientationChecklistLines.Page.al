#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51481 "Orientation Checklist Lines"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Staff Orientation Checklist";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Item;Item)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = ListStyle;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = ListStyle;
                }
                field(Timeline;Timeline)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = ListStyle;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    StyleExpr = ListStyle;

                    trigger OnValidate()
                    begin
                         //Style:
                         if Status  = Status::Completed then
                         ListStyle := 'Favorable'
                         else if Status  = Status::"Not Applicable" then
                         ListStyle := 'Ambiguous'
                         else if Status  = Status::Pending then
                         ListStyle := 'Standard';
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
         //Style:
         if Status  = Status::Completed then
         ListStyle := 'Favorable'
         else if Status  = Status::"Not Applicable" then
         ListStyle := 'Ambiguous'
         else if Status  = Status::Pending then
         ListStyle := 'Standard';
    end;

    trigger OnAfterGetRecord()
    begin
         //Style:
         if Status  = Status::Completed then
         ListStyle := 'Favorable'
         else if Status  = Status::"Not Applicable" then
         ListStyle := 'Ambiguous'
         else if Status  = Status::Pending then
         ListStyle := 'Standard';
    end;

    var
        ListStyle: Text;
}

