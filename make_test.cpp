#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>
#include <sstream>
#include <vector>

using namespace std;

const string VARS  = "vars ";
const string SKIP  = "skip";
const string IFPOS = "ifpos";
const string THEN  = "then";
const string ELSE  = "else";
const string END   = "end";

string global_var_str = "";
extern string stmts_gen();

vector<string> token_gen(string var_str)
{
    vector<string> result;
    stringstream data(var_str);
    string line;

    while (getline(data, line, ','))
        result.push_back(line);

    for (int i = 0; i < result.size(); ++i)
    {
        string val = result[i];
        string::iterator end_pos = remove(val.begin(), val.end(), ' ');
        val.erase(end_pos, val.end());
        result[i] = val;
    }

    return result;
}

string id_gen(int iter)
{
    string val;

    for (int i = 0; i < iter; ++i)
    {
        int len = rand() % 5 + 1;
        int low_num = 0;
        int high_num = 0;

        for (int i = 0; i < len; ++i) {
            int coin = rand() % 2;
            if (coin == 0) {
                low_num = 65;
                high_num = 90;
            }
            else
            {
                low_num = 97;
                high_num = 122;
            }
            val = val + static_cast<char>(rand() % (high_num - low_num) + low_num);
        }

        if(i != iter - 1)
            val = val + ", ";
    }

    return val;
}

string skip_gen()
{
    return SKIP;
}

string cond_gen(string var_str)
{
    string cond_str;
    vector<string> str_vec = token_gen(global_var_str);
    string var = str_vec[rand() % str_vec.size()];
    cond_str = IFPOS + ' ' + var + '\n' + THEN
            + '\n' + stmts_gen() + '\n' + ELSE
            + '\n' + stmts_gen() + '\n' + END;
    return cond_str;
}

string assign_gen(string var_str) {
    string res_str;
    vector<string> result = token_gen(global_var_str);
    int rnd_var = rand() % result.size();
    int coin = rand() % 2;
    if (coin)
        res_str = result[rnd_var] + ":=" + to_string((rand() % 10) - 5);
    else
    {
        string val = result[rand() % result.size()];
        res_str = result[rnd_var] + ":=" + val;
    }

    return res_str;
}

string stmt_gen()
{
    string result;
    int chance = (rand() % 3) + 1;
    switch (chance)
    {
        case 1:
            result = skip_gen();
            break;
        case 2:
            result = assign_gen(global_var_str);
            break;
        case 3:
            result = cond_gen(global_var_str);
            break;
        default:
            break;
    }
    return result;
}

string stmts_gen()
{
    int coin = rand() % 2;
    if (coin)
        return stmt_gen();
    else
        return stmt_gen() + ',' + stmts_gen();
}

int main()
{
    srand(time(nullptr));

    ofstream out_file;
    out_file.open ("input.vsl");

    int var_num = (rand() % 5) + 1;
    global_var_str = id_gen(var_num);

    out_file << VARS << global_var_str << endl;

    out_file << stmts_gen() << endl;

    out_file.close();

    return 0;
}


