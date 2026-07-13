Page 51047 "HMS Observation Form Proc"
{
    PageType = ListPart;
    SourceTable = "HMS Observation Form Line Proc";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(ProcessNo; Rec."Process No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Process No. field.';

                    trigger OnValidate()
                    begin
                        //getprosessname("Process No.",ProsessNo);
                        ProcessName := Rec."Process Name";
                    end;
                }
                field(ProcessResult; Rec."Process Result")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Process Result field.';
                }
                field(ProcessMandatory; Rec."Process Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Process Mandatory field.';
                }
                field(ProcessRemarks; Rec."Process Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Process Remarks field.';
                }
            }
        }
    }

    actions { }

    var
        ProcessName: Text[100];

    local procedure getprosessname()
    begin
        /*"Process No.".RESET;
        IF "Process No.".GET(ProcessNo) THEN
          BEGIN
          ProcessName:="Process Name"
          END;
           */
        ProcessName := Rec."Process Name";
        Rec.Insert;

    end;
}

