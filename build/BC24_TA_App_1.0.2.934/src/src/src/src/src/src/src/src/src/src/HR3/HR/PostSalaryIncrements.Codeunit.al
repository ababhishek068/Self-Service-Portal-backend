Codeunit 50016 "Post Salary Increments"
{

    trigger OnRun()
    begin
    end;

    var
        salaryregister: Record "Salary Increament Register";
        hrSalaryCard: Record "pr Salary Card";

    procedure postRegister()
    begin
        if ((Date2dmy(Today, 2) <> 1) and (Date2dmy(Today, 2) <> 7)) then
            Error('Salary inrement are only done in January and July');

        if (Date2dmy(Today, 2) = 1) then begin // 1
                                               // Post Inreaments for January
            salaryregister.Reset;
            salaryregister.SetRange(salaryregister.Posted, false);
            salaryregister.SetRange(salaryregister."Increament Month", 'January');
            salaryregister.SetRange(salaryregister."Increament Year", (Date2dmy(Today, 3)));
            if salaryregister.Find('-') then begin //3
                repeat
                begin //4
                    hrSalaryCard.Reset;
                    hrSalaryCard.SetRange(hrSalaryCard."Employee Code", salaryregister."Employee No.");
                    if hrSalaryCard.Find('-') then begin //5
                        hrSalaryCard."Basic Pay" := salaryregister."Current Salary";
                        hrSalaryCard.Modify;
                        salaryregister.Posted := true;
                        salaryregister.Reversed := false;
                        salaryregister.Modify;
                    end;//5
                end;//4
                until salaryregister.Next = 0;
                Message('Salary increament for ''JANUARY'' ,''' + Format((Date2dmy(Today, 3))) + ''' Posted Successfully.' +
                '\You can reverse these postings before ''JANUARY'' ends.');
            end //3
            else begin //11
                Error('The Register has not been popullated with Increments.');
            end;// 11

        end // 1
        else
            if (Date2dmy(Today, 2) = 7) then begin //2
                                                   // Post Increaments for July

                // Post Inreaments for January
                salaryregister.Reset;
                salaryregister.SetRange(salaryregister.Posted, false);
                salaryregister.SetRange(salaryregister."Increament Month", 'JULY');
                salaryregister.SetRange(salaryregister."Increament Year", (Date2dmy(Today, 3)));
                if salaryregister.Find('-') then begin //7
                    repeat
                    begin //9
                        hrSalaryCard.Reset;
                        hrSalaryCard.SetRange(hrSalaryCard."Employee Code", salaryregister."Employee No.");
                        if hrSalaryCard.Find('-') then begin //8
                            hrSalaryCard."Basic Pay" := salaryregister."Current Salary";
                            hrSalaryCard.Modify;
                            salaryregister.Posted := true;
                            salaryregister.Reversed := false;
                            salaryregister.Modify;
                        end;//8
                    end;//9
                    until salaryregister.Next = 0;
                    Message('Salary increament for ''JULY'',' + Format((Date2dmy(Today, 3))) + ''' Posted Successfully.' +
                    '\You can reverse these postings before ''JULY'',' + Format((Date2dmy(Today, 3))) + ''' ends.');
                end //7
                else begin //11
                    Error('The Register has not been popullated with Increments.');
                end;// 11

            end;//2
    end;

    procedure ReverseInrementPosting()
    begin
        if ((Date2dmy(Today, 2) <> 1) and (Date2dmy(Today, 2) <> 7)) then
            Error('Salary inrement are only done in January and July');

        if (Date2dmy(Today, 2) = 1) then begin // 1
                                               // Reverse Inrements for January
            salaryregister.Reset;
            salaryregister.SetRange(salaryregister.Posted, true);
            salaryregister.SetRange(salaryregister."Increament Month", 'January');
            salaryregister.SetRange(salaryregister."Increament Year", (Date2dmy(Today, 3)));
            if salaryregister.Find('-') then begin //3
                repeat
                begin //4
                    hrSalaryCard.Reset;
                    hrSalaryCard.SetRange(hrSalaryCard."Employee Code", salaryregister."Employee No.");
                    if hrSalaryCard.Find('-') then begin //5
                        hrSalaryCard."Basic Pay" := salaryregister."Prev. Salary";
                        hrSalaryCard.Modify;
                        salaryregister.Posted := false;
                        salaryregister.Reversed := true;
                        salaryregister.Modify;
                    end;//5
                end;//4
                until salaryregister.Next = 0;
                Message('Salary increament for ''JANUARY'' ,''' + Format((Date2dmy(Today, 3))) + ''' Reversed Successfully.' +
                '\You can Re-Post these postings before ''JANUARY'' ends.');
            end //3
            else begin //10
                Error('The Register has not been popullated with Increments.');
            end;//10
        end // 1
        else
            if (Date2dmy(Today, 2) = 7) then begin //2
                                                   // Post Increaments for July

                // Post Inreaments for January
                salaryregister.Reset;
                salaryregister.SetRange(salaryregister.Posted, true);
                salaryregister.SetRange(salaryregister."Increament Month", 'JULY');
                salaryregister.SetRange(salaryregister."Increament Year", (Date2dmy(Today, 3)));
                if salaryregister.Find('-') then begin //7
                    repeat
                    begin //9
                        hrSalaryCard.Reset;
                        hrSalaryCard.SetRange(hrSalaryCard."Employee Code", salaryregister."Employee No.");
                        if hrSalaryCard.Find('-') then begin //8
                            hrSalaryCard."Basic Pay" := salaryregister."Prev. Salary";
                            hrSalaryCard.Modify;
                            salaryregister.Posted := false;
                            salaryregister.Reversed := true;
                            salaryregister.Modify;
                        end;//8
                    end;//9
                    until salaryregister.Next = 0;
                    Message('Salary increament for ''JULY'',' + Format((Date2dmy(Today, 3))) + ''' Reversed Successfully.' +
                    '\You can Re-Post these postings before ''JULY'',' + Format((Date2dmy(Today, 3))) + ''' ends.');
                end //7
                else begin //11
                    Error('The Register has not been popullated with Increments.');
                end;// 11

            end;//2
    end;
}

