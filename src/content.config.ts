import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const projects = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects' }),
  schema: z.object({
    title: z.string(),
    summary: z.string(),
    status: z.enum(['in-development', 'active', 'shipped', 'archived']),
    year: z.string(),
    stack: z.array(z.string()),
    featured: z.boolean().default(false),
    order: z.number().default(99),
    links: z
      .object({
        github: z.string().url().optional(),
        site: z.string().url().optional(),
      })
      .default({}),
  }),
});

const garden = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/garden' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    stage: z.enum(['seedling', 'budding', 'evergreen']),
    planted: z.coerce.date(),
    tended: z.coerce.date(),
    topics: z.array(z.string()).default([]),
  }),
});

export const collections = { projects, garden };
