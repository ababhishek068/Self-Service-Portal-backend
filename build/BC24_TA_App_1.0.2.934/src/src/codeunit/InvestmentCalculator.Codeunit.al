Codeunit 50012 "Investment Calculator"
{
    //   """
    //     This codeunit calculates the investment interest and no of days for each investment
    //   """


    trigger OnRun()
    begin
        Investment.Reset;
        Investment.SetFilter(Investment."Investment Rollover Status", '<>%1', Investment."investment rollover status"::Closed);
        if Investment.Find('-') then begin
            repeat
                if Today < Investment."Investment End Date" then
                    DaysElapsed := Today - Investment."Investment Start Date"
                else
                    DaysElapsed := Investment."Investment End Date" - Investment."Investment Start Date";
                Investment."No of days elapsed" := DaysElapsed;
                Investment.CalcFields(Investment."Investment Principal");
                Interest := Investment."Investment Principal" * (Investment."Investment Rate" / 100) *
                  (DaysElapsed / (Investment."Investment End Date" - Investment."Investment Start Date"));
                Investment."Interest Earned" := Interest;
                Investment."Investment Withholding Tax" := Interest * (Investment."Withholding Tax Rate" / 100);
                Investment.Modify;
            until Investment.Next = 0;
        end;
    end;

    var
        Investment: Record "Investment Header";
        DaysElapsed: Integer;
        Interest: Decimal;
}

