report 50053 "Asset Service Alert"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("ICT Service/Maintenance Req"; "ICT Service/Maintenance Req")
        {
            trigger OnPreDataItem()
            begin
                if HRSetup.Get() then;
            end;

            trigger OnAfterGetRecord()
            var
                msg: Text;
                WebP: Codeunit HRWebportal;
            begin
                if "Next Service Date" >= Today then begin
                    if HRSetup."ICT Email" <> '' then begin
                        msg := '';
                        msg := 'Dear ICT Officer,<br /><br />';
                        msg := msg + 'The next Service/Maintenance date for ' + "Asset No." + '(' + "Asset Description" + ')' + ' is due on' + Format("Next Service Date") + '.<br /><br />';

                        WebP.SendEmail(HRSetup."ICT Email", 'Service/Maintenance Alert', msg);
                    end;
                end;
            end;
        }

    }
    var
        HRSetup: Record "HR Setup";
}