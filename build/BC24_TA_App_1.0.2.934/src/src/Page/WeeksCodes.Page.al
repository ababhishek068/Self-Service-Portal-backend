Page 51133 "Weeks  Codes"
{
    PageType = List;
    SourceTable = "Weeks Codes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Startdate1)
            {
                field(SDate; SDate)
                {
                    caption = 'Start Date';
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
            }
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Day field.';
                }
                field(StartDate; Rec."Start Date")
                {
                    caption = 'Date';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Inactive; Rec.Inactive)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inactive field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Generate)
            {
                ApplicationArea = basic;
                image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Generate action.';
                trigger OnAction()
                var
                    Wk: Record "Weeks Codes";
                    i, j, k : integer;
                begin
                    if SDate = 0D then error('The Starting date can not be empty');
                    wk.reset;
                    wk.DeleteAll();
                    for i := 1 to 14 do begin
                        for j := 1 to 7 do begin
                            k := K + 1;
                            wk.init;
                            if STRLEN(Format(i)) = 1 then
                                wk.Code := 'WK0' + format(i)
                            else
                                wk.Code := 'WK' + format(i);
                            wk."Start Date" := SDate + k;
                            wk.Day := format(sdate + j, 0, '<Weekday Text>');
                            wk.insert;
                        end;
                    end;
                end;
            }
        }
    }
    var
        SDate: date;
}

