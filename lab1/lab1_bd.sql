--Step 1--
CREATE TABLE MyTable (
    id  NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,--auto-increment
    val INTEGER
);
DROP TABLE MyTable;

select * from MyTable;

--Step 2--
--Creating anonim block and fill in random values
DECLARE
    random_number NUMBER;
BEGIN
    FOR i IN 1..100
    LOOP
        random_number := dbms_random.value(1,10);
        INSERT INTO MyTable (val) VALUES (random_number);
    END LOOP;
END;

--Step 3--
--Function counter even and odd numbers
CREATE OR REPLACE FUNCTION counter_equals RETURN INTEGER IS
    even_counter INTEGER;
    odd_counter INTEGER;
BEGIN
    SELECT COUNT(*) INTO even_counter FROM MyTable WHERE MOD(val, 2) = 0;
    SELECT COUNT(*) INTO odd_counter FROM MyTable WHERE MOD(val, 2) <> 0;
    IF even_counter > odd_counter THEN
        dbms_output.put_line('TRUE');
    ELSIF even_counter < odd_counter THEN
        dbms_output.put_line('FALSE');
    ELSE
        dbms_output.put_line('EQUAL');
    END IF;
    RETURN even_counter;
END;

DECLARE
    call_func INTEGER;
BEGIN
    call_func := counter_equals();
END;

--Step 4--
--Generating string INSERT
CREATE OR REPLACE FUNCTION get_insert_str (id_ NUMBER) RETURN VARCHAR2
IS
  v_val  NUMBER;
  v_stm VARCHAR2(100);
BEGIN
  SELECT val INTO v_val FROM MyTable WHERE id = id_;
  v_stm := 'INSERT INTO MyTable (id, val) VALUES (' || id_ || ', ' || v_val || ');';
  DBMS_OUTPUT.PUT_LINE(v_stm);
  RETURN v_stm;
END;

DECLARE
    stm VARCHAR2(100);
BEGIN
    stm := get_insert_str(8);
END;

--Step 5--
CREATE OR REPLACE FUNCTION crud RETURN NUMBER
IS
  success NUMBER;
BEGIN
    INSERT INTO MyTable (val) VALUES (228);
    UPDATE MyTable set val = 229 WHERE id = 1;
    DELETE FROM MyTable WHERE id = 1;
  success := 1;
  RETURN success;
END;

DECLARE
    success NUMBER;
BEGIN
    success := crud();
END;

--Step 6
CREATE OR REPLACE FUNCTION calc(
  month_salary NUMBER,
  bonus_rate NUMBER
) RETURN NUMBER
IS
  result_ NUMBER;
BEGIN
  IF month_salary <= 0 OR bonus_rate <= 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Wrong input');
  END IF;

  result_ := (1 + bonus_rate / 100) * 12 * month_salary;

  RETURN result_;
END;

DECLARE
    result_ NUMBER;
BEGIN
    result_ := calc(500, 100);
    dbms_output.put_line(result_);
END;
