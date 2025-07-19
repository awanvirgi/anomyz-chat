'use client';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_KEY;
export const supabase = createClient(supabaseUrl, supabaseKey);

// ✅ Utility logger (hanya tampil di development)
const isDev = process.env.NODE_ENV === 'development';
function logError(...args) {
    if (isDev) {
        console.error(...args);
    }
}

// ✅ Create Account
export async function createAccount(nama) {
    try {
        const { data, error } = await supabase.auth.signInAnonymously({
            options: {
                data: { name: nama },
            },
        });

        if (error) {
            logError('Supabase Error:', error);
            return [];
        }
        return data;
    } catch (err) {
        logError('Function Error:', err);
        return [];
    }
}

// ✅ Update User
export async function UpdateUser() {
    try {
        await supabase.auth.updateUser({
            data: {
                anonymous: true,
                last_active: new Date().toISOString(),
            },
        });
    } catch (err) {
        logError('Function Error:', err);
    }
}

// ✅ Select Single Row with Filter
export async function selectSingleFilterRowTable(tableName, select, eq, filterValue) {
    try {
        const { data, error } = await supabase
            .from(tableName)
            .select(select)
            .eq(eq, filterValue)
            .maybeSingle();

        if (error) {
            if (tableName !== 'member_room') logError('Supabase Error:', error);
            return [];
        }
        return data;
    } catch (err) {
        logError('Function Error:', err);
        return [];
    }
}

// ✅ Select Multiple Rows with Filter
export async function selectFilterRowTable(tableName, select, eq, filterValue) {
    try {
        const { data, error } = await supabase
            .from(tableName)
            .select(select)
            .eq(eq, filterValue);

        if (error) {
            logError('Supabase Error:', error);
            return [];
        }
        return data;
    } catch (err) {
        logError('Function Error:', err);
        return [];
    }
}

// ✅ Insert Row
export async function InsertTable(tableName, value) {
    try {
        const { data, error } = await supabase.from(tableName).insert([value]);

        if (error) {
            logError('Supabase Error:', error);
            return [];
        }
        return data;
    } catch (err) {
        logError('Function Error:', err);
        return [];
    }
}

// ✅ Insert Row and return single
export async function InsertSingleTable(tableName, value) {
    try {
        const { data, error } = await supabase
            .from(tableName)
            .insert([value])
            .select()
            .single();

        if (error) {
            logError('Supabase Error:', error);
            return [];
        }
        return data;
    } catch (err) {
        logError('Function Error:', err);
        return [];
    }
}

// ✅ Delete by single column
export async function DeleteSingleColumnTable(tableName, nameColumn, value) {
    try {
        const { error } = await supabase.from(tableName).delete().eq(nameColumn, value);

        if (error) logError('Supabase Error:', error);
        return [];
    } catch (err) {
        logError('Function Error:', err);
        return [];
    }
}

// ✅ Delete by two filters
export async function Delete2FilterTable(tableName, nameColumn1, nameColumn2, value1, value2) {
    try {
        const { error } = await supabase
            .from(tableName)
            .delete()
            .eq(nameColumn1, value1)
            .eq(nameColumn2, value2);

        if (error) logError('Supabase Error:', error);
        return [];
    } catch (err) {
        logError('Function Error:', err);
        return [];
    }
}
